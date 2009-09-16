From: akpm@linux-foundation.org
Subject: + kallsyms-fix-segfault-in-prefix_underscores_count.patch added to -mm tree
Date: Wed, 16 Sep 2009 16:26:02 -0700
Message-ID: <200909162326.n8GNQ3TM018217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760492AbZIPX14 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Sep 2009 19:27:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu, pmarques@grupopie.com, sam@ravnborg.org, stable@kernel.org


The patch titled
     kallsyms: fix segfault in prefix_underscores_count()
has been added to the -mm tree.  Its filename is
     kallsyms-fix-segfault-in-prefix_underscores_count.patch

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
Subject: kallsyms: fix segfault in prefix_underscores_count()
From: Paul Mundt <lethal@linux-sh.org>

Commit b478b782e110fdb4135caa3062b6d687e989d994 "kallsyms, tracing: output
more proper symbol name" introduces a "bugfix" that introduces a segfault
in kallsyms in my configurations.

The cause is the introduction of prefix_underscores_count() which attempts
to count underscores, even in symbols that do not have them.  As a result,
it just uselessly runs past the end of the buffer until it crashes:

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
/bin/sh: line 1: 16934 Done                    sh-linux-gnu-nm -n .tmp_vmlinux1
     16935 Segmentation fault      | scripts/kallsyms > .tmp_kallsyms1.S
make: *** [.tmp_kallsyms1.S] Error 139

This simplifies the logic and just does a straightforward count.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paulo Marques <pmarques@grupopie.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>		[2.6.30.x, 2.6.31.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kallsyms.c~kallsyms-fix-segfault-in-prefix_underscores_count scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-fix-segfault-in-prefix_underscores_count
+++ a/scripts/kallsyms.c
@@ -585,7 +585,7 @@ static int prefix_underscores_count(cons
 {
 	const char *tail = str;
 
-	while (*tail != '_')
+	while (*tail == '_')
 		tail++;
 
 	return tail - str;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
linux-next.patch
mtd-make-onenand-genericc-more-generic.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
kallsyms-fix-segfault-in-prefix_underscores_count.patch
mmc-make-the-configuration-memory-resource-optional.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch

