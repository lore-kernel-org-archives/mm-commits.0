From: akpm@linux-foundation.org
Subject: [merged] ctags-remove-struct-forward-declarations.patch removed from -mm tree
Date: Mon, 19 Dec 2011 13:28:52 -0800
Message-ID: <20111219212853.220E620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64275 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1LSV2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2011 16:28:54 -0500
Received: by mail-ey0-f202.google.com with SMTP id d1so176372eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2011 13:28:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: ctags: remove struct forward declarations
has been removed from the -mm tree.  Its filename was
     ctags-remove-struct-forward-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ctags: remove struct forward declarations

They're quite pointless and obscure location of real structure definition.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/tags.sh~ctags-remove-struct-forward-declarations scripts/tags.sh
--- a/scripts/tags.sh~ctags-remove-struct-forward-declarations
+++ a/scripts/tags.sh
@@ -167,6 +167,8 @@ exuberant()
 	--langdef=dotconfig --language-force=dotconfig          \
 	--regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
 
+	# Remove structure forward declarations.
+	LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
 }
 
 emacs()
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-parse-mount-options.patch
procfs-add-hidepid=-and-gid=-mount-options.patch
procfs-remove-superfluous-debug-output.patch
procfs-add-hidepid=-and-gid=-mount-options-fix.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch

