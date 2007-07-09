From: akpm@linux-foundation.org
Subject: - fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mode-update.patch removed from -mm tree
Date: Mon, 09 Jul 2007 12:56:21 -0700
Message-ID: <200707091956.l69JuLdx007312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756235AbXGIT5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 15:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mmarek@suse.cz, dgc@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat =
mode (fix)
has been removed from the -mm tree.  Its filename was
     fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mod=
e-update.patch

This patch was dropped because it was folded into fix-xfs_ioc_fsbulksta=
t_single-and-xfs_ioc_fsinumbers-in-compat-mode.patch

------------------------------------------------------
Subject: Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in com=
pat mode (fix)
=46rom: Michal Marek <mmarek@suse.cz>

On Thu, Jun 28, 2007 at 11:15:30AM -0700, Andrew Morton wrote:
>   CC      fs/xfs/linux-2.6/xfs_ioctl32.o
> fs/xfs/linux-2.6/xfs_ioctl32.c: In function =E2=80=98xfs_ioc_bulkstat=
_compat=E2=80=99:
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: =E2=80=98xfs_inumbers_fmt_=
compat=E2=80=99 undeclared (first use in this function)
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: (Each undeclared identifie=
r is reported only once
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: for each function it appea=
rs in.)

Sorry, the #define was wrong. This one should work better (at least
build-tested on ppc64 this time):

Signed-off-by: Michal Marek <mmarek@suse.cz>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl32.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/xfs/linux-2.6/xfs_ioctl32.c~fix-xfs_ioc_fsbulkstat_single-=
and-xfs_ioc_fsinumbers-in-compat-mode-update fs/xfs/linux-2.6/xfs_ioctl=
32.c
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c~fix-xfs_ioc_fsbulkstat_single-and-=
xfs_ioc_fsinumbers-in-compat-mode-update
+++ a/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -153,7 +153,7 @@ STATIC int xfs_inumbers_fmt_compat(
=20
 #else
=20
-#define xfs_inumbers_fmt_compat(a, b, c, d) xfs_inumbers_fmt(a, b, c, =
d)
+#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
 #define _PACKED
=20
 #endif
_

Patches currently in -mm which might be from mmarek@suse.cz are

fix-xfs_ioc_fsgeometry_v1-in-compat-mode.patch
fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mod=
e.patch
fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mode.pat=
ch
fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mode-upd=
ate.patch
