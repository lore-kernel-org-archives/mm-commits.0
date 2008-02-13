From: akpm@linux-foundation.org
Subject: + fs-coda-remove-static-inline-forward-declarations.patch added to -mm tree
Date: Wed, 13 Feb 2008 10:41:44 -0800
Message-ID: <200802131841.m1DIfiLn007478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYBMSm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 13:42:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi, jaharkes@cs.cmu.edu, penberg@cs.helsinki.fi


The patch titled
     fs/coda: remove static inline forward declarations
has been added to the -mm tree.  Its filename is
     fs-coda-remove-static-inline-forward-declarations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: fs/coda: remove static inline forward declarations
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

They're defined later on in the same file with bodies and nothing in
between needs them.

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/coda_linux.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/coda_linux.h~fs-coda-remove-static-inline-forwa=
rd-declarations include/linux/coda_linux.h
--- a/include/linux/coda_linux.h~fs-coda-remove-static-inline-forward-d=
eclarations
+++ a/include/linux/coda_linux.h
@@ -43,9 +43,6 @@ int coda_getattr(struct vfsmount *, stru
 int coda_setattr(struct dentry *, struct iattr *);
=20
 /* this file:  heloers */
-static __inline__ struct CodaFid *coda_i2f(struct inode *);
-static __inline__ char *coda_i2s(struct inode *);
-static __inline__ void coda_flag_inode(struct inode *, int flag);
 char *coda_f2s(struct CodaFid *f);
 int coda_isroot(struct inode *i);
 int coda_iscontrol(const char *name, size_t length);
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch
fs-coda-remove-static-inline-forward-declarations.patch
