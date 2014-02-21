From: akpm@linux-foundation.org
Subject: + kallsyms-fix-absolute-addresses-for-kaslr.patch added to -mm
 tree
Date: Fri, 21 Feb 2014 12:20:43 -0800
Message-ID: <5307b51b.GSlmm/DcExPsN1a5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaBUUUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:20:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, mmarek@suse.cz, ahonig@google.com, keescook@chromium.org

Subject: + kallsyms-fix-absolute-addresses-for-kaslr.patch added to -mm tree
To: keescook@chromium.org,ahonig@google.com,mmarek@suse.cz,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:20:43 -0800


The patch titled
     Subject: kallsyms: fix absolute addresses for kASLR
has been added to the -mm tree.  Its filename is
     kallsyms-fix-absolute-addresses-for-kaslr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kallsyms-fix-absolute-addresses-for-kaslr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kallsyms-fix-absolute-addresses-for-kaslr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kallsyms: fix absolute addresses for kASLR


Currently symbols that are absolute addresses are incorrectly
displayed in /proc/kallsyms if the kernel is loaded with kASLR.

The problem was that the scripts/kallsyms.c file which generates
the array of symbol names and addresses uses an relocatable value
for all symbols, even absolute symbols.  This patch fixes that.

Several kallsyms output in different boot states for comparison:

$ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.nokaslr
0000000000000000 D __per_cpu_start
0000000000014280 D __per_cpu_end
ffffffff810001c8 T _stext
$ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr1
000000001f200000 D __per_cpu_start
000000001f214280 D __per_cpu_end
ffffffffa02001c8 T _stext
$ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr2
000000000d400000 D __per_cpu_start
000000000d414280 D __per_cpu_end
ffffffff8e4001c8 T _stext
$ egrep '_(stext|_per_cpu_(start|end))' /root/kallsyms.kaslr-fixed
0000000000000000 D __per_cpu_start
0000000000014280 D __per_cpu_end
ffffffffadc001c8 T _stext

Signed-off-by: Andy Honig <ahonig@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN scripts/kallsyms.c~kallsyms-fix-absolute-addresses-for-kaslr scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-fix-absolute-addresses-for-kaslr
+++ a/scripts/kallsyms.c
@@ -330,8 +330,7 @@ static void write_src(void)
 				printf("\tPTR\t_text + %#llx\n",
 					table[i].addr - _text);
 			else
-				printf("\tPTR\t_text - %#llx\n",
-					_text - table[i].addr);
+				printf("\tPTR\t%#llx\n", table[i].addr);
 		} else {
 			printf("\tPTR\t%#llx\n", table[i].addr);
 		}
_

Patches currently in -mm which might be from keescook@chromium.org are

makefile-fix-extra-parenthesis-typo-when-cc_stackprotector_regular-is-enabled.patch
makefile-fix-build-with-make-380-again.patch
backing_dev-fix-hung-task-on-sync.patch
kallsyms-fix-absolute-addresses-for-kaslr.patch
vsprintf-remove-%n-handling.patch
lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

