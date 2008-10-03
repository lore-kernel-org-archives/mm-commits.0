From: akpm@linux-foundation.org
Subject: + cpu_alloc-remove-useless-variable.patch added to -mm tree
Date: Fri, 03 Oct 2008 00:34:32 -0700
Message-ID: <200810030734.m937YWL4016757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754373AbYJCHfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 03:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux-foundation.org, penberg@cs.helsinki.fi, rusty@rustcorp.com.au


The patch titled
     cpu_alloc: remove useless variable
has been added to the -mm tree.  Its filename is
     cpu_alloc-remove-useless-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu_alloc: remove useless variable
From: Christoph Lameter <cl@linux-foundation.org>

The "units" variable is a leftover and has no function at this point.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cpu_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/cpu_alloc.c~cpu_alloc-remove-useless-variable mm/cpu_alloc.c
--- a/mm/cpu_alloc.c~cpu_alloc-remove-useless-variable
+++ a/mm/cpu_alloc.c
@@ -27,8 +27,6 @@
 #define UNIT_TYPE int
 #define UNIT_SIZE sizeof(UNIT_TYPE)
 
-int units;	/* Actual available units */
