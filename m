From: akpm@linux-foundation.org
Subject: + c-r-introduce-checkpoint_restore-symbol.patch added to -mm tree
Date: Mon, 12 Dec 2011 13:53:49 -0800
Message-ID: <201112122153.pBCLroWs029816@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:47242 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1LLVx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2011 16:53:56 -0500
Received: by qcsg15 with SMTP id g15so689996qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2011 13:53:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, avagin@openvz.org, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org


The patch titled
     Subject: c/r: introduce CHECKPOINT_RESTORE symbol
has been added to the -mm tree.  Its filename is
     c-r-introduce-checkpoint_restore-symbol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: introduce CHECKPOINT_RESTORE symbol

For checkpoint/restore we need auxilary features being compiled into the
kernel, such as additional prctl codes, /proc/<pid>/map_files and etc... 
but same time these features are not mandatory for a regular kernel so
CHECKPOINT_RESTORE config symbol should bring a way to disable them all at
once if one wish to get rid of additional functionality.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN init/Kconfig~c-r-introduce-checkpoint_restore-symbol init/Kconfig
--- a/init/Kconfig~c-r-introduce-checkpoint_restore-symbol
+++ a/init/Kconfig
@@ -782,6 +782,17 @@ config DEBUG_BLK_CGROUP
 
 endif # CGROUPS
 
+config CHECKPOINT_RESTORE
+	bool "Checkpoint/restore support" if EXPERT
+	default n
+	help
+	  Enables additional kernel features in a sake of checkpoint/restore.
+	  In particular it adds auxiliary prctl codes to setup process text,
+	  data and heap segment sizes, and a few additional /proc filesystem
+	  entries.
+
+	  If unsure, say N here.
+
 menuconfig NAMESPACES
 	bool "Namespaces support" if EXPERT
 	default !EXPERT
_
Subject: Subject: c/r: introduce CHECKPOINT_RESTORE symbol

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
sysctl-add-the-kernelns_last_pid-control.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

