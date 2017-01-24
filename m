From: akpm@linux-foundation.org
Subject: + zswap-disable-changing-params-if-init-fails.patch added to -mm
 tree
Date: Tue, 24 Jan 2017 13:24:50 -0800
Message-ID: <5887c622.uzAHSBIpQYn/ESoN%akpm__7511.55878319896$1485293110$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdAXVYw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 16:24:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, dan.streetman@canonical.com, marcin@mejor.pl, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, sjenning@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: disable changing params if init fails
has been added to the -mm tree.  Its filename is
     zswap-disable-changing-params-if-init-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-disable-changing-params-if-init-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-disable-changing-params-if-init-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: disable changing params if init fails

Add zswap_init_failed bool that prevents changing any of the module
params, if init_zswap() fails, and set zswap_enabled to false.  Change
'enabled' param to a callback, and check zswap_init_failed before allowing
any change to 'enabled', 'zpool', or 'compressor' params.

Any driver that is built-in to the kernel will not be unloaded if its init
function returns error, and its module params remain accessible for users
to change via sysfs.  Since zswap uses param callbacks, which assume that
zswap has been initialized, changing the zswap params after a failed
initialization will result in WARNING due to the param callbacks expecting
a pool to already exist.  This prevents that by immediately exiting any of
the param callbacks if initialization failed.

This was reported here:
https://marc.info/?l=linux-mm&m=147004228125528&w=4

And fixes this WARNING:
[  429.723476] WARNING: CPU: 0 PID: 5140 at mm/zswap.c:503
__zswap_pool_current+0x56/0x60

Fixes: 90b0fc26d5db ("zswap: change zpool/compressor at runtime")
Link: http://lkml.kernel.org/r/20170124200259.16191-2-ddstreet@ieee.org
Signed-off-by: Dan Streetman <dan.streetman@canonical.com>
Reported-by: Marcin Miroslaw <marcin@mejor.pl>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN mm/zswap.c~zswap-disable-changing-params-if-init-fails mm/zswap.c
--- a/mm/zswap.c~zswap-disable-changing-params-if-init-fails
+++ a/mm/zswap.c
@@ -78,7 +78,13 @@ static u64 zswap_duplicate_entry;
 
 /* Enable/disable zswap (disabled by default) */
 static bool zswap_enabled;
-module_param_named(enabled, zswap_enabled, bool, 0644);
+static int zswap_enabled_param_set(const char *,
+				   const struct kernel_param *);
+static struct kernel_param_ops zswap_enabled_param_ops = {
+	.set =		zswap_enabled_param_set,
+	.get =		param_get_bool,
+};
+module_param_cb(enabled, &zswap_enabled_param_ops, &zswap_enabled, 0644);
 
 /* Crypto compressor to use */
 #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
@@ -176,6 +182,9 @@ static atomic_t zswap_pools_count = ATOM
 /* used by param callback function */
 static bool zswap_init_started;
 
+/* fatal error during init */
+static bool zswap_init_failed;
+
 /*********************************
 * helpers and fwd declarations
 **********************************/
@@ -624,6 +633,11 @@ static int __zswap_param_set(const char
 	char *s = strstrip((char *)val);
 	int ret;
 
+	if (zswap_init_failed) {
+		pr_err("can't set param, initialization failed\n");
+		return -ENODEV;
+	}
+
 	/* no change required */
 	if (!strcmp(s, *(char **)kp->arg))
 		return 0;
@@ -703,6 +717,17 @@ static int zswap_zpool_param_set(const c
 	return __zswap_param_set(val, kp, NULL, zswap_compressor);
 }
 
+static int zswap_enabled_param_set(const char *val,
+				   const struct kernel_param *kp)
+{
+	if (zswap_init_failed) {
+		pr_err("can't enable, initialization failed\n");
+		return -ENODEV;
+	}
+
+	return param_set_bool(val, kp);
+}
+
 /*********************************
 * writeback code
 **********************************/
@@ -1201,6 +1226,9 @@ hp_fail:
 dstmem_fail:
 	zswap_entry_cache_destroy();
 cache_fail:
+	/* if built-in, we aren't unloaded on failure; don't allow use */
+	zswap_init_failed = true;
+	zswap_enabled = false;
 	return -ENOMEM;
 }
 /* must be late so crypto has time to come up */
_

Patches currently in -mm which might be from ddstreet@ieee.org are

zswap-disable-changing-params-if-init-fails.patch
zswap-allow-initialization-at-boot-without-pool.patch
zswap-clear-compressor-or-zpool-param-if-invalid-at-init.patch

