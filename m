From: akpm@linux-foundation.org
Subject: - fs-coda-remove-static-inline-forward-declarations.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:47 -0700
Message-ID: <200804300538.m3U5clrq028777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359AbYD3FjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, jaharkes@cs.cmu.edu, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     fs/coda: remove static inline forward declarations
has been removed from the -mm tree.  Its filename was
     fs-coda-remove-static-inline-forward-declarations.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
