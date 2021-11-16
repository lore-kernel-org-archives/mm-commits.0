Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EF3C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 21:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E506E61263
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 21:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhKPVqh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 16:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhKPVqh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 16:46:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C522961A53;
        Tue, 16 Nov 2021 21:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637099019;
        bh=tB+L5uYKOKJDPnF5ROPvQkAK73tgb2/ib3eeA3S3nRE=;
        h=Date:From:To:Subject:From;
        b=vnJXO7OC6CuqzfGSbSD42C+PmMC0YG720X7WSMWVr4uttpvRGZzB+Zko7OIiqumt6
         mu47/FThXhwKMOT6aML2HHu3zKt8QDviVABDshXB0N4Kukn8WeQV6Qts+BmmL8ndDJ
         j1XhelkjMZHBYHqiJI3D+or56GDSSBlkwSZ+Yz7o=
Date:   Tue, 16 Nov 2021 13:43:39 -0800
From:   akpm@linux-foundation.org
To:     agruenba@redhat.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?gup-avoid-multiple-user-access-locking-unlocking-in-fault?=
 =?US-ASCII?Q?=5Fin=5Fread-writeable.patch?= added to -mm tree
Message-ID: <20211116214339.eHkSH7V9i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gup: avoid multiple user access locking/unlocking in fault_in_{read/write}able
has been added to the -mm tree.  Its filename is
     gup-avoid-multiple-user-access-locking-unlocking-in-fault_in_read-writeable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gup-avoid-multiple-user-access-locking-unlocking-in-fault_in_read-writeable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gup-avoid-multiple-user-access-locking-unlocking-in-fault_in_read-writeable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: gup: avoid multiple user access locking/unlocking in fault_in_{read/write}able

fault_in_readable() and fault_in_writeable() perform __get_user() and
__put_user() in a loop, implying multiple user access locking/unlocking.

To avoid that, use user access blocks.

Link: https://lkml.kernel.org/r/720dcf79314acca1a78fae56d478cc851952149d.1637084492.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/gup.c~gup-avoid-multiple-user-access-locking-unlocking-in-fault_in_read-writeable
+++ a/mm/gup.c
@@ -1672,21 +1672,22 @@ size_t fault_in_writeable(char __user *u
 
 	if (unlikely(size == 0))
 		return 0;
+	if (!user_write_access_begin(uaddr, size))
+		return size;
 	if (!PAGE_ALIGNED(uaddr)) {
-		if (unlikely(__put_user(0, uaddr) != 0))
-			return size;
+		unsafe_put_user(0, uaddr, out);
 		uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
 	}
 	end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
 	if (unlikely(end < start))
 		end = NULL;
 	while (uaddr != end) {
-		if (unlikely(__put_user(0, uaddr) != 0))
-			goto out;
+		unsafe_put_user(0, uaddr, out);
 		uaddr += PAGE_SIZE;
 	}
 
 out:
+	user_write_access_end();
 	if (size > uaddr - start)
 		return size - (uaddr - start);
 	return 0;
@@ -1771,21 +1772,22 @@ size_t fault_in_readable(const char __us
 
 	if (unlikely(size == 0))
 		return 0;
+	if (!user_read_access_begin(uaddr, size))
+		return size;
 	if (!PAGE_ALIGNED(uaddr)) {
-		if (unlikely(__get_user(c, uaddr) != 0))
-			return size;
+		unsafe_get_user(c, uaddr, out);
 		uaddr = (const char __user *)PAGE_ALIGN((unsigned long)uaddr);
 	}
 	end = (const char __user *)PAGE_ALIGN((unsigned long)start + size);
 	if (unlikely(end < start))
 		end = NULL;
 	while (uaddr != end) {
-		if (unlikely(__get_user(c, uaddr) != 0))
-			goto out;
+		unsafe_get_user(c, uaddr, out);
 		uaddr += PAGE_SIZE;
 	}
 
 out:
+	user_read_access_end();
 	(void)c;
 	if (size > uaddr - start)
 		return size - (uaddr - start);
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

gup-avoid-multiple-user-access-locking-unlocking-in-fault_in_read-writeable.patch

