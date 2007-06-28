From: akpm@linux-foundation.org
Subject: + dm-compile-error-when-config_dm_netlink-is-not-defined.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:14:51 -0700
Message-ID: <200706282214.l5SMEp8Y002696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763129AbXF1WO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaggy@linux.vnet.ibm.com


The patch titled
     dm: compile error when CONFIG_DM_NETLINK is not defined
has been added to the -mm tree.  Its filename is
     dm-compile-error-when-config_dm_netlink-is-not-defined.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm: compile error when CONFIG_DM_NETLINK is not defined
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

On Thu, 2007-06-28 at 03:43 -0700, Andrew Morton wrote:
> -agk-dm-dm-use-singlethread-workqueues.patch
> +agk-dm-dm-use-singlethread-workqueues.patch
> +agk-dm-dm-snapshot-fix-invalidation-deadlock.patch
> +agk-dm-dm-snapshot-permit-invalid-activation.patch
> +agk-dm-dm-raid1-clear-region-outside-spinlock.patch
> +agk-dm-dm-netlink.patch
> +agk-dm-dm-netlink-add-to-core.patch
> +agk-dm-dm-netlink-mpath.patch
> +agk-dm-dm-mpath-rdac.patch
>
>  device mapper tree updates

I got this compile error:

  LD      drivers/md/built-in.o
drivers/md/dm-multipath.o: In function `dm_path_event':
drivers/md/dm-netlink.h:56: multiple definition of `dm_path_event'
drivers/md/dm-mod.o:drivers/md/dm-netlink.h:56: first defined here
drivers/md/dm-multipath.o: In function `dm_netlink_send_events':
drivers/md/dm-netlink.h:51: multiple definition of `dm_netlink_send_events'
drivers/md/dm-mod.o:drivers/md/dm-netlink.h:51: first defined here
make[2]: *** [drivers/md/built-in.o] Error 1

I was able to fix it by making the dummy inline functions static.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-netlink.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-netlink.h~dm-compile-error-when-config_dm_netlink-is-not-defined drivers/md/dm-netlink.h
--- a/drivers/md/dm-netlink.h~dm-compile-error-when-config_dm_netlink-is-not-defined
+++ a/drivers/md/dm-netlink.h
@@ -47,10 +47,10 @@ static inline int __init dm_netlink_init
 static inline void dm_netlink_exit(void)
 {
 }
-void inline dm_netlink_send_events(struct list_head *events)
+static void inline dm_netlink_send_events(struct list_head *events)
 {
 }
-void inline dm_path_event(enum dm_netlink_event_type evt_type,
+static void inline dm_path_event(enum dm_netlink_event_type evt_type,
 			  struct dm_table *t, const char *path,
 			  int nr_valid_paths)
 {
_

Patches currently in -mm which might be from shaggy@linux.vnet.ibm.com are

dm-compile-error-when-config_dm_netlink-is-not-defined.patch
git-jfs.patch
introduce-i_sync.patch
knfsd-exportfs-remove-iget-abuse.patch
