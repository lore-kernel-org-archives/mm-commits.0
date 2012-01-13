From: akpm@linux-foundation.org
Subject: [merged] c-r-introduce-checkpoint_restore-symbol.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:18 -0800
Message-ID: <20120113203719.3632420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:21 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, avagin@openvz.org, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: introduce CHECKPOINT_RESTORE symbol
has been removed from the -mm tree.  Its filename was
     c-r-introduce-checkpoint_restore-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -783,6 +783,17 @@ config DEBUG_BLK_CGROUP
 
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

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch

