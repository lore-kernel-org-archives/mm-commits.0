From: akpm@linux-foundation.org
Subject: + ctags-remove-struct-forward-declarations.patch added to -mm tree
Date: Wed, 30 Nov 2011 12:59:10 -0800
Message-ID: <201111302059.pAUKxABM015290@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:43790 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1K3U7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 15:59:12 -0500
Received: by ywb26 with SMTP id 26so141768ywb.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 12:59:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mmarek@suse.cz


The patch titled
     Subject: ctags: remove struct forward declarations
has been added to the -mm tree.  Its filename is
     ctags-remove-struct-forward-declarations.patch

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
Subject: Subject: ctags: remove struct forward declarations

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
ctags-remove-struct-forward-declarations.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-parse-mount-options.patch
procfs-add-hidepid=-and-gid=-mount-options.patch

