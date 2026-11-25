Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585325;
	b=yk90AX9Y2k1VPgXs+YpiHFIKt957o2HBtxi3+3wM0NeTzpn0IshB9mtdNPkGk8PdFcTm
	 KpUTO/ie9QnfDFpD6pcU9OReuvcBDIFBEou5w1V/zWythdcGVzfEnBj0zFeGGJv7rWgiA
	 A3SpooM+QcG7YNqAoqvB6K626XoOg8+9ybcujQ7AFOQHDGvmj6x+caQcKaGVhrNuhwYJN
	 72fmmS5dUtQxhX4ldpZHTixV7FQenlWwNW2AM52ha9qo6Qi7uOjZ02ESHpZDySkFqumF+
	 bRvjR3eMOZQP/DU9NtLWLGibj8E367AH97HHzgA79AelwFg52vwPLrTRGCfJAmXM8yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585325;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=nuyhuvZUyTRMvUEulUUU5QQYFFQk7aiz6/x1PZu+vO0=;
	b=HHm6Y5zGGCg4HzRnPQ6K1TvUbSI8oj8YCFd7mHdluwl+4HLe7cliaI4zkxfvG0y8eDzn
	 Pkmm+yxx4YSE7cpl4RqAciJdWVN0uNCKKjUhh/eK36EUHU9NrDIZ3egKf1bF6rfXx1AVy
	 xfmuH2C+tlfvIB4qzdvF957gFPOobHSW9UY9SfyuFGY90wd9OgJa9+3IxRUXfMmdK1nq4
	 oLkP2xF4dggmmwLhHAkRW/iBzwFVp9PWOjLOgLgCEZK4ju9qaLY2P+ABzwD6iIQqEUIS/
	 m/BgCHTBMVN/PfgbBJRb6QOuXbWYayNpJ7/S72Ha5hAf2/yf6jqbo7RFDFBIlSKl/YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jFkG4fae;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D76606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jFkG4fae
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04DF1F000C0;
	Wed, 25 Nov 2026 05:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585325;
	bh=nuyhuvZUyTRMvUEulUUU5QQYFFQk7aiz6/x1PZu+vO0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=jFkG4faeb3MEMqaqTwFgXn51v23G0AgJ/8RBZ1fXR1tCHAypT2BJQsCml51fiPTnb
	 eVCoxw77Mfw2AgBGqPeFYI1P2S5+vaibEFB6FM4uMfJx00Gx01QtzYecEiSUbJ+WkZ
	 9RgSkx4nSN2ugWu4XOxB8QfLmD+6FyrHzBP3dyd8=
Date: Tue, 24 Nov 2026 21:42:04 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-24-phillip@squashfs.org.uk>
References: <20261123034304.261742-24-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch removed from -mm tree
Message-Id: <20261125054204.E04DF1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
has been removed from the -mm tree.  Its filename was
     squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
Date: Mon, 23 Nov 2026 03:43:04 +0000

The previous commits in this patch-set now sanity check index before
squashfs_read_data() is called.  However, it is always wise to take
a belts and braces approach and sanity check at the lowest level to
trap any values that could slip through.

Link: https://patch.msgid.link/20261123034304.261742-24-phillip@squashfs.org.uk
Fixes: e2780ab159ac ("Squashfs: block operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/block.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/squashfs/block.c~squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data
+++ a/fs/squashfs/block.c
@@ -297,6 +297,15 @@ int squashfs_read_data(struct super_bloc
 	int res;
 	int offset;
 
+	/*
+	 * Reject index values greater than possible filesystem size (S64_MAX).
+	 * This also ensures the index variable doesn't overflow in the function.
+	 */
+	if (index > S64_MAX) {
+		res = -EIO;
+		goto out;
+	}
+
 	if (length) {
 		/*
 		 * Datablock.
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


