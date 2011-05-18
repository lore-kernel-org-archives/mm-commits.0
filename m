From: akpm@linux-foundation.org
Subject: [merged] proc_fs-add-stub-for-proc_mkdir_mode.patch removed from -mm tree
Date: Wed, 18 May 2011 11:27:47 -0700
Message-ID: <201105181827.p4IIRFL6015183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933388Ab1ERSey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 14:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adobriyan@gmail.com, linville@tuxdriver.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     procfs: add stub for proc_mkdir_mode()
has been removed from the -mm tree.  Its filename was
     proc_fs-add-stub-for-proc_mkdir_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: add stub for proc_mkdir_mode()
From: Randy Dunlap <randy.dunlap@oracle.com>

Provide a stub for proc_mkdir_mode() when CONFIG_PROC_FS is not
enabled, just like the stub for proc_mkdir().

Fixes this linux-next build error:
drivers/net/wireless/airo.c:4504: error: implicit declaration of function 'proc_mkdir_mode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proc_fs.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/proc_fs.h~proc_fs-add-stub-for-proc_mkdir_mode include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc_fs-add-stub-for-proc_mkdir_mode
+++ a/include/linux/proc_fs.h
@@ -208,6 +208,8 @@ static inline struct proc_dir_entry *pro
 		struct proc_dir_entry *parent,const char *dest) {return NULL;}
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
 	struct proc_dir_entry *parent) {return NULL;}
+static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
+	mode_t mode, struct proc_dir_entry *parent) { return NULL; }
 
 static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *base, 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
w1-add-1-wire-w1-ds2408-8-channel-addressable-switch-support-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

