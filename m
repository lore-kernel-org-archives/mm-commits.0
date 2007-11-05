From: akpm@linux-foundation.org
Subject: + cpm_load_patch-declartion-conflict.patch added to -mm tree
Date: Mon, 05 Nov 2007 12:20:31 -0800
Message-ID: <200711052020.lA5KKVIn017988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbXKEUUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 15:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     cpm_load_patch() - declartion conflict
has been added to the -mm tree.  Its filename is
     cpm_load_patch-declartion-conflict.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpm_load_patch() - declartion conflict
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

The build fails with following error

  CC      arch/powerpc/sysdev/micropatch.o
arch/powerpc/sysdev/micropatch.c:625: error: conflicting types for `cpm_load_patch'
include/asm/commproc.h:94: error: previous declaration of `cpm_load_patch' was here
arch/powerpc/sysdev/micropatch.c: In function `cpm_load_patch':
arch/powerpc/sysdev/micropatch.c:630: warning: unused variable `smp'
arch/powerpc/sysdev/micropatch.c:629: warning: unused variable `spp'
arch/powerpc/sysdev/micropatch.c:628: warning: unused variable `iip'
make[1]: *** [arch/powerpc/sysdev/micropatch.o] Error 1
make: *** [arch/powerpc/sysdev] Error 2

The commit f2a0bd3753dad7ea4605ebd5435716b39e9f92bb defines the function
with void cpm_load_patch(cpm8xx_t *cp) prtotype and is declared as
extern void cpm_load_patch(volatile immap_t *immr) in the header file.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/commproc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-powerpc/commproc.h~cpm_load_patch-declartion-conflict include/asm-powerpc/commproc.h
--- a/include/asm-powerpc/commproc.h~cpm_load_patch-declartion-conflict
+++ a/include/asm-powerpc/commproc.h
@@ -91,7 +91,7 @@ extern uint m8xx_cpm_hostalloc(uint size
 extern int  m8xx_cpm_hostfree(uint start);
 extern void m8xx_cpm_hostdump(void);
 
-extern void cpm_load_patch(volatile immap_t *immr);
+extern void cpm_load_patch(cpm8xx_t *cp);
 
 /* Buffer descriptors used by many of the CPM protocols.
 */
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

missing-include-file-in-kallsymsh.patch
cpm_load_patch-declartion-conflict.patch
