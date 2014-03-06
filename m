From: akpm@linux-foundation.org
Subject: [merged] kallsyms-fix-absolute-addresses-for-kaslr.patch removed
 from -mm tree
Date: Thu, 06 Mar 2014 12:37:38 -0800
Message-ID: <5318dc92.ehKzFbUM82EumVFK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaCFUhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, mmarek@suse.cz, keescook@chromium.org, ahonig@google.com

Subject: [merged] kallsyms-fix-absolute-addresses-for-kaslr.patch removed from -mm tree
To: ahonig@google.com,keescook@chromium.org,mmarek@suse.cz,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:38 -0800


The patch titled
     Subject: kallsyms: fix absolute addresses for kASLR
has been removed from the -mm tree.  Its filename was
     kallsyms-fix-absolute-addresses-for-kaslr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Honig <ahonig@google.com>
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

Patches currently in -mm which might be from ahonig@google.com are

origin.patch
revert-kallsyms-fix-absolute-addresses-for-kaslr.patch
linux-next.patch

