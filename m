Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406648;
	b=NJpGVyQHVf/UlbuEWCLWH7NnafIizA5QibsvvhFaWAreCLlnWmnt6NaExZiCnZq2Gjmu
	 dufV2qLTz27HiMygx0w+oc/0w5HwqzHlRvFDxuuGuyCYMoheA3HD0FzGpga9q0YxZp/NQ
	 IHnF/KX+yjbzuyRYnt9fn0rQaK5v67jImwxwtqnrfb7RgzrN5c36tWNz+ILegse06am6E
	 gytF4h9J2qFAqoMBnPrjI9MHxN73rjnXI2D38EuGC/aSjTzt44sbBwPwAodNwKn3b2OQN
	 Dzv0t4aLRASd8LTkY9myBgPjvOsUb2wMCSTeT/NI2knYpKNy0zGLtqFC4ngZ4BM5g1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406648;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=LbjyhSTmzaFz9RlgdMSgj87fcK92pjiZqyINnS4Wv+E=;
	b=ifxOr61KwuAfF+4hA3y6AJufbgHWzAjrdpBAYaXL4U0Anu9hnsdUChH7tY/a1AP5l07t
	 +xbvXfwXUOe2Jy5wJKyImgkaSqA2J7IHXLkgNOJpiuedonIDczdtZg1uDJsvGJJ06dD3s
	 9n0e3Hp2wdwYlso5GkhOwuqyVA+FISH0vlMaTGInVp2Vi7XtslDn7vpZyBA1T+jwTuwSm
	 d2KjOLnhstkAq/OLkSED7vRJA+Ri7U0UwMre3Ob1GMEMee0dEWuXJjIekZ2bByWP0MktF
	 c7t8jn1jp/ts1buTjwER1je1c1MGtqU09bzkglPNblnlZb/mitAdumzcxb95viSG5sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zo2KEIOO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23211606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zo2KEIOO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E4C1F000D8;
	Mon, 23 Nov 2026 04:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406647;
	bh=LbjyhSTmzaFz9RlgdMSgj87fcK92pjiZqyINnS4Wv+E=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Zo2KEIOOryookLD81ctubBiIzlYAelvXgcb7DuR8qi38ooqlV09+iDMniORFR6ulp
	 rvYpA8RpUSRvKPmyHW4Ny1kLXlyDCROQ2XqdS+X5xrHhNdUNnrWcdYIrKPKI7JPwwR
	 ADMf6OJqrn3dr/vRzaiXhuPxJCvQjicl3l/wh34A=
Date: Sun, 22 Nov 2026 20:04:07 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-23-phillip@squashfs.org.uk>
References: <20261111234402.252354-23-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch removed from -mm tree
Message-Id: <20261123040407.95E4C1F000D8@smtp.kernel.org>
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
Date: Wed, 11 Nov 2026 23:44:02 +0000

The previous commits in this patch-set now sanity check index before
squashfs_read_data() is called.  However, it is always wise to take
a belts and braces approach and sanity check at the lowest level to
trap any values that could slip through.

Link: https://patch.msgid.link/20261111234402.252354-23-phillip@squashfs.org.uk
Fixes: e2780ab159ac ("Squashfs: block operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

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

a.patch

