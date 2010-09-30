From: akpm@linux-foundation.org
Subject: + kconfig-dont-go-out-from-read-config-loop-when-you-read-new-symbol.patch added to -mm tree
Date: Thu, 30 Sep 2010 15:49:58 -0700
Message-ID: <201009302249.o8UMnwX4024157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060Ab0I3Wuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Sep 2010 18:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: naota@elisp.net, mmarek@suse.cz


The patch titled
     kconfig: don't go out from read config loop when you read new symbol
has been added to the -mm tree.  Its filename is
     kconfig-dont-go-out-from-read-config-loop-when-you-read-new-symbol.patch

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
Subject: kconfig: don't go out from read config loop when you read new symbol
From: Naohiro Aota <naota@elisp.net>

commit 8baefd30b5b0101aa07aa75da44a9eee881eed28 of linux-next replaced
a `switch()' statement with some `if()' statements, but left `break's
in the `switch()' statement untouched. This cause read config loop to
exit and so "make oldconfig" is not much usable (see below).

> $ make oldconfig
><snip>
> scripts/kconfig/conf --oldconfig Kconfig
> #
> # using defaults found in /boot/config-2.6.34-ccs-r1
> #
> *
> * Restart config...
> *
> *
> * General setup
> *
> Prompt for development and/or incomplete code/drivers (EXPERIMENTAL) [N/y/?] (NEW)

(I've already have "CONFIG_EXPERIMENTAL=y" in the old config file. But
that's not read here.)

This patch should fix this problem.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/confdata.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/confdata.c~kconfig-dont-go-out-from-read-config-loop-when-you-read-new-symbol scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-dont-go-out-from-read-config-loop-when-you-read-new-symbol
+++ a/scripts/kconfig/confdata.c
@@ -234,7 +234,7 @@ load:
 				sym = sym_find(line + 9);
 				if (!sym) {
 					sym_add_change_count(1);
-					break;
+					goto setsym;
 				}
 			} else {
 				sym = sym_lookup(line + 9, 0);
@@ -273,7 +273,7 @@ load:
 				sym = sym_find(line + 7);
 				if (!sym) {
 					sym_add_change_count(1);
-					break;
+					goto setsym;
 				}
 			} else {
 				sym = sym_lookup(line + 7, 0);
@@ -293,6 +293,7 @@ load:
 			conf_warning("unexpected data");
 			continue;
 		}
+setsym:
 		if (sym && sym_is_choice_value(sym)) {
 			struct symbol *cs = prop_get_symbol(sym_get_choice_prop(sym));
 			switch (sym->def[def].tri) {
_

Patches currently in -mm which might be from naota@elisp.net are

linux-next.patch
idr-fix-idr_pre_get-locking-description.patch
idr-fix-idr_pre_get-locking-description-fix.patch
kconfig-dont-go-out-from-read-config-loop-when-you-read-new-symbol.patch

