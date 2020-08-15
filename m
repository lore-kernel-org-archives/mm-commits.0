Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30B7C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A093220657
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529540;
	bh=4ezhMfTvQ6DKf/rvPdBQqJDKMDzigCKkI5KbmITVWXw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=yzd0EXBE092koUSQc95Xor+eN06p0jN4+vdiwqaLKLBA3sLSl6iDM2YOMz1zPdSaW
	 0vfO+jWdBik31eMD6NeT4XCQvs31wwW0L8mebpLsSJqs6MhWf+EkkEOusEhsd23bTe
	 gDtQ2Ip8XB3Elq0DJRWc+b97iempNTtyy9d9+gUk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgHOWMS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbgHOWK2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F401222BF3;
        Sat, 15 Aug 2020 00:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451447;
        bh=4ezhMfTvQ6DKf/rvPdBQqJDKMDzigCKkI5KbmITVWXw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PCSX1pW/G4qze3rmFTA9uriZF3eJle1aYnOSkms5X5TZaBeNnqjCNK/Z2u4FAQqm8
         OUv726Tv20UdrFtIC2lTmMj7XDiqUkrCyX08/DJopxy8t/uvmLPIX89S1PqiD/4jc6
         irjEB6kD7i3yPQJX6Zngv15K/XOATOZJz++97BMs=
Date:   Fri, 14 Aug 2020 17:30:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, raven@themaw.net,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 14/39] fs: autofs: delete repeated words in
 comments
Message-ID: <20200815003046.h_CYnc3X0%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs: autofs: delete repeated words in comments

Drop duplicated words {the, at} in comments.

Link: http://lkml.kernel.org/r/20200811021817.24982-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/dev-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/autofs/dev-ioctl.c~fs-autofs-delete-repeated-words-in-comments
+++ a/fs/autofs/dev-ioctl.c
@@ -20,7 +20,7 @@
  * another mount. This situation arises when starting automount(8)
  * or other user space daemon which uses direct mounts or offset
  * mounts (used for autofs lazy mount/umount of nested mount trees),
- * which have been left busy at at service shutdown.
+ * which have been left busy at service shutdown.
  */
 
 typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *,
@@ -496,7 +496,7 @@ static int autofs_dev_ioctl_askumount(st
  * located path is the root of a mount we return 1 along with
  * the super magic of the mount or 0 otherwise.
  *
- * In both cases the the device number (as returned by
+ * In both cases the device number (as returned by
  * new_encode_dev()) is also returned.
  */
 static int autofs_dev_ioctl_ismountpoint(struct file *fp,
_
