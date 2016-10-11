From: akpm@linux-foundation.org
Subject: [patch 086/102] scripts/tags.sh: enable code completion in VIM
Date: Tue, 11 Oct 2016 13:55:14 -0700
Message-ID: <57fd51b2.Lxyk/gQU6uIJSz96%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38429 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbcJKU5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mathieu.maret@gmail.com, mmarek@suse.cz

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
@@ -263,7 +263,8 @@ exuberant()
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL,ACPI_EXPORT_SYMBOL   \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	-I static,const						\
-	--extra=+f --c-kinds=+px --langmap=c:+.h "${regex[@]}"
+	--extra=+fq --c-kinds=+px --fields=+iaS --langmap=c:+.h \
+	"${regex[@]}"
 
 	setup_regex exuberant kconfig
 	all_kconfigs | xargs $1 -a                              \
_
