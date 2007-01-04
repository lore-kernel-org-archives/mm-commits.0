From: akpm@osdl.org
Subject: + add-const-for-timespecval_compare-arguments.patch added to -mm tree
Date: Thu, 04 Jan 2007 13:32:43 -0800
Message-ID: <200701042132.l04LWhVw031905@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:55463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964885AbXADVcz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 16:32:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de


The patch titled
     Add const for time{spec,val}_compare arguments
has been added to the -mm tree.  Its filename is
     add-const-for-timespecval_compare-arguments.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add const for time{spec,val}_compare arguments
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

The arguments are really const.  Mark them const to allow these functions
being called from places where the arguments are const without getting
useless compiler warnings.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/time.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/time.h~add-const-for-timespecval_compare-arguments include/linux/time.h
--- a/include/linux/time.h~add-const-for-timespecval_compare-arguments
+++ a/include/linux/time.h
@@ -46,7 +46,7 @@ static inline int timespec_equal(struct 
  * lhs == rhs: return 0
  * lhs > rhs:  return >0
  */
-static inline int timespec_compare(struct timespec *lhs, struct timespec *rhs)
+static inline int timespec_compare(const struct timespec *lhs, const struct timespec *rhs)
 {
 	if (lhs->tv_sec < rhs->tv_sec)
 		return -1;
@@ -55,7 +55,7 @@ static inline int timespec_compare(struc
 	return lhs->tv_nsec - rhs->tv_nsec;
 }
 
-static inline int timeval_compare(struct timeval *lhs, struct timeval *rhs)
+static inline int timeval_compare(const struct timeval *lhs, const struct timeval *rhs)
 {
 	if (lhs->tv_sec < rhs->tv_sec)
 		return -1;
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

remove-extra-newline-from-info-message.patch
fix-scsi-scsi_transporth-compile-error.patch
add-const-for-timespecval_compare-arguments.patch
