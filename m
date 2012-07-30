From: akpm@linux-foundation.org
Subject: + dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch added to -mm tree
Date: Mon, 30 Jul 2012 15:20:48 -0700
Message-ID: <20120730222049.61D6E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:35191 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2G3WUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 18:20:50 -0400
Received: by obbwc20 with SMTP id wc20so4043267obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 15:20:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, davem@davemloft.net, gregkh@linuxfoundation.org, jbaron@redhat.com, jim.cromie@gmail.com, kay@vrfy.org


The patch titled
     Subject: dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2
has been added to the -mm tree.  Its filename is
     dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2

Changes in v2:

o Fix dynamic_emit_prefix to always initialize output
o Call create_syslog_header and emit_printk from__netdev_printk and
  eliminate call to dev_printk to remove another recursion via %pV

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    8 +++++---
 net/core/dev.c      |   19 ++++++++++++++-----
 2 files changed, 19 insertions(+), 8 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2 lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2
+++ a/lib/dynamic_debug.c
@@ -521,6 +521,8 @@ static char *dynamic_emit_prefix(const s
 	int pos_after_tid;
 	int pos = 0;
 
+	*buf = '\0';
+
 	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
 			pos += snprintf(buf + pos, remaining(pos), "<intr> ");
@@ -576,7 +578,6 @@ int __dynamic_dev_dbg(struct _ddebug *de
 	struct va_format vaf;
 	va_list args;
 	int res;
-	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
@@ -589,6 +590,7 @@ int __dynamic_dev_dbg(struct _ddebug *de
 	if (!dev) {
 		res = printk(KERN_DEBUG "(NULL device *): %pV", &vaf);
 	} else {
+		char buf[PREFIX_SIZE];
 		char dict[128];
 		size_t dictlen;
 
@@ -632,11 +634,11 @@ int __dynamic_netdev_dbg(struct _ddebug 
 					       dict, sizeof(dict));
 
 		res = printk_emit(0, 7, dictlen ? dict : NULL, dictlen,
-				  "%s%s %s: %pV",
+				  "%s%s %s %s: %pV",
 				  dynamic_emit_prefix(descriptor, buf),
 				  dev_driver_string(dev->dev.parent),
+				  dev_name(dev->dev.parent),
 				  netdev_name(dev), &vaf);
-
 	} else if (dev) {
 		res = printk(KERN_DEBUG "%s: %pV", netdev_name(dev), &vaf);
 	} else {
diff -puN net/core/dev.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2 net/core/dev.c
--- a/net/core/dev.c~dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2
+++ a/net/core/dev.c
@@ -6407,13 +6407,22 @@ static int __netdev_printk(const char *l
 {
 	int r;
 
-	if (dev && dev->dev.parent)
-		r = dev_printk(level, dev->dev.parent, "%s: %pV",
-			       netdev_name(dev), vaf);
-	else if (dev)
+	if (dev && dev->dev.parent) {
+		char dict[128];
+		size_t dictlen = create_syslog_header(dev->dev.parent,
+						      dict, sizeof(dict));
+
+		r = printk_emit(0, level[1] - '0',
+				dictlen ? dict : NULL, dictlen,
+				"%s %s %s: %pV",
+				dev_driver_string(dev->dev.parent),
+				dev_name(dev->dev.parent),
+				netdev_name(dev), &vaf);
+	} else if (dev) {
 		r = printk("%s%s: %pV", level, netdev_name(dev), vaf);
-	else
+	} else {
 		r = printk("%s(NULL net_device): %pV", level, vaf);
+	}
 
 	return r;
 }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
sound-use-printk_get_level-and-printk_skip_level.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch
vsprintf-add-%pmr-for-bluetooth-mac-address.patch
vsprintf-add-support-of-%ph.patch
checkpatch-update-alignment-check.patch
checkpatch-test-for-non-standard-signatures.patch
checkpatch-check-usleep_range-arguments.patch
checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
checkpatch-add-checks-for-do-while-0-macro-misuses.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch

