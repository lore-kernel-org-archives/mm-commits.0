From: akpm@linux-foundation.org
Subject: - build-failure-on-axonram.patch removed from -mm tree
Date: Fri, 12 Oct 2007 15:25:45 -0700
Message-ID: <200710122225.l9CMPjW2006571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933455AbXJLWbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Oct 2007 18:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     build failure on axonram
has been removed from the -mm tree.  Its filename was
     build-failure-on-axonram.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: build failure on axonram
=46rom: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Hi Andrew,

The build fails with the following error message.

  CC      arch/powerpc/sysdev/axonram.o
arch/powerpc/sysdev/axonram.c:120:34: error: macro "bio_io_error" passe=
d 2 arguments, but takes just 1
arch/powerpc/sysdev/axonram.c: In function =E2=80=98axon_ram_make_reque=
st=E2=80=99:
arch/powerpc/sysdev/axonram.c:120: error: =E2=80=98bio_io_error=E2=80=99=
 undeclared (first use in this function)
arch/powerpc/sysdev/axonram.c:120: error: (Each undeclared identifier i=
s reported only once
arch/powerpc/sysdev/axonram.c:120: error: for each function it appears =
in.)
arch/powerpc/sysdev/axonram.c:134: error: too many arguments to functio=
n =E2=80=98bio_endio=E2=80=99
make[1]: *** [arch/powerpc/sysdev/axonram.o] Error 1
make: *** [arch/powerpc/sysdev] Error 2

The patch fixes the build failure.

Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/axonram.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/sysdev/axonram.c~build-failure-on-axonram arch/p=
owerpc/sysdev/axonram.c
--- a/arch/powerpc/sysdev/axonram.c~build-failure-on-axonram
+++ a/arch/powerpc/sysdev/axonram.c
@@ -117,7 +117,7 @@ axon_ram_make_request(struct request_que
 	transfered =3D 0;
 	bio_for_each_segment(vec, bio, idx) {
 		if (unlikely(phys_mem + vec->bv_len > phys_end)) {
-			bio_io_error(bio, bio->bi_size);
+			bio_io_error(bio);
 			rc =3D -ERANGE;
 			break;
 		}
@@ -131,7 +131,7 @@ axon_ram_make_request(struct request_que
 		phys_mem +=3D vec->bv_len;
 		transfered +=3D vec->bv_len;
 	}
-	bio_endio(bio, transfered, 0);
+	bio_endio(bio, 0);
=20
 	return rc;
 }
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.co=
m are

git-nfsd.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patc=
h
use-extended-crashkernel-command-line-on-ia64-fix.patch
