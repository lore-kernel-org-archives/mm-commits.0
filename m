From: akpm@linux-foundation.org
Subject: + padata-add-parenthesis-in-max_seq_nr-macro.patch added to -mm tree
Date: Wed, 26 May 2010 16:28:15 -0700
Message-ID: <201005262328.o4QNSF3j021042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853Ab0EZX3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 May 2010 19:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, herbert@gondor.hengli.com.au, steffen.klassert@secunet.com


The patch titled
     padata: add parenthesis in MAX_SEQ_NR macro
has been added to the -mm tree.  Its filename is
     padata-add-parenthesis-in-max_seq_nr-macro.patch

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
Subject: padata: add parenthesis in MAX_SEQ_NR macro
From: Dan Carpenter <error27@gmail.com>

MAX_SEQ_NR is used in padata_alloc_pd() like this:

        pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;

It needs parenthesis or the divide by num_cpus takes precedence over the
subtraction.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/padata.c~padata-add-parenthesis-in-max_seq_nr-macro kernel/padata.c
--- a/kernel/padata.c~padata-add-parenthesis-in-max_seq_nr-macro
+++ a/kernel/padata.c
@@ -28,7 +28,7 @@
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 
-#define MAX_SEQ_NR INT_MAX - NR_CPUS
+#define MAX_SEQ_NR (INT_MAX - NR_CPUS)
 #define MAX_OBJ_NUM 1000
 
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
proc-cleanup-remove-unused-assignments.patch
linux-next.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
padata-add-parenthesis-in-max_seq_nr-macro.patch

