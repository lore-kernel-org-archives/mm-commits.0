From: akpm@linux-foundation.org
Subject: + enable-code-completion-in-vim.patch added to -mm tree
Date: Tue, 30 Aug 2016 13:36:26 -0700
Message-ID: <57c5ee4a.9kyViY+Jl+7wOt0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44347 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbcH3Ug1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2016 16:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.maret@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: enable code completion in VIM
has been added to the -mm tree.  Its filename is
     enable-code-completion-in-vim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/enable-code-completion-in-vim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/enable-code-completion-in-vim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mathieu Maret <mathieu.maret@gmail.com>
Subject: scripts/tags.sh: enable code completion in VIM

Vim, with the omnicppcomplete(#1) plugin, can do code completion using
information build by ctags.  Add flags needed by omnicppcomplete(#2) to
have completion on member of structure.

1: https://github.com/vim-scripts/omnicppcomplete
2: https://github.com/vim-scripts/OmniCppComplete/blob/master/doc/omnicppcomplete.txt#L93

Link: http://lkml.kernel.org/r/20160830191546.4469-1-mathieu.maret@gmail.com
Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/tags.sh~enable-code-completion-in-vim scripts/tags.sh
--- a/scripts/tags.sh~enable-code-completion-in-vim
+++ a/scripts/tags.sh
@@ -264,7 +264,8 @@ exuberant()
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL,ACPI_EXPORT_SYMBOL   \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	-I static,const						\
-	--extra=+f --c-kinds=+px --langmap=c:+.h "${regex[@]}"
+	--extra=+fq --c-kinds=+px --fields=+iaS --langmap=c:+.h \
+	"${regex[@]}"
 
 	setup_regex exuberant kconfig
 	all_kconfigs | xargs $1 -a                              \
_

Patches currently in -mm which might be from mathieu.maret@gmail.com are

enable-code-completion-in-vim.patch

