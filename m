Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415122;
	b=d8l3XzuL4yb0E9ZMMLEI6h0Pe+FAB+TJxWqRr1VTfWuCWvZSt3l+rQY2EpJWt359ip6x
	 U4tNy95mgFxinicHGlwpWFwFcxRJ9knGOkFcO0O86MCdKt4QFbReAlbuCfs0zmjnQCW8j
	 8igwXqe+zW01ZqXu2hynRQeVqGtKvq8PbrnQfdcnB27lw+3Y7qB8OTgJpojvcKVDTeoZQ
	 pYElOeJUF/yUhsoaB2b+ctxIbR5D4VP7mx68mpl4oZ9ZMx5PPcVTtr+YelpgbF4EEVlum
	 v/aSBRVTAieuOL+n9Jh8PJzDoctzZFGco6PWEWGTkOzPJgmXG358rkbymtgaa2vCntg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415122;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=XPN1MOvK5gk35OoBSkn58TaJvxRSnN53SqThAw2Ak5s=;
	b=l9ndO5KGSf27VKtUicsSqZ9R7ky4/AEBeeNI9kH9vonF4j1rSh5iJbaIEthlZwVF7F1E
	 71aiz7qwNzGvka0Z8CsmVSoeaLAKnHPz3IEQl62TUcgTUDsIQHmF7+p2UXUgJidGNFdg7
	 EUbILApoIrnqvVH/Ln4A0lhoIJjk9tlY5qb4vladwbyTdPqIBrruQuhB6xP0Q8WAyGssi
	 PsXFOquhIDPyDxWDXEup6rWA2aXjUAYE/D6U5M1H5LAg/sQj2wekYApvGeyElrLdQdQtY
	 +TRklY77iVGfdJmJHCHc86u5aijrM7q8D2eMv3hpiyJnGUEZAGPB28toYfNj1zsammQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IPbabZTt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6996D606A327;
	Mon, 23 Nov 2026 06:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IPbabZTt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57931F000C6;
	Mon, 23 Nov 2026 06:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415121;
	bh=XPN1MOvK5gk35OoBSkn58TaJvxRSnN53SqThAw2Ak5s=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=IPbabZTt3/dbm+IhnofDlqgqhGj2qCRlnYriY+1N3G2x2A3MF/x7yvVPewJnM1A/A
	 7++ZIFsmh/W2bAKty6wGekiXHFdUNnd4KSMRRrg6qQJ0AaZeqoYgg9fuuSEpknhyZP
	 geqRWOYMY9YPc+gCShh3hf6g3gfbJtd5gmq9bg18=
Date: Sun, 22 Nov 2026 22:25:21 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,stable@vger.kernel.org,
	shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,
	chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,aquini@redhat.com,
	oleksandr@natalenko.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261118112610.122799-1-oleksandr@natalenko.name>
References: <20261118112610.122799-1-oleksandr@natalenko.name>
Subject: [merged mm-hotfixes-stable] mm-swapfile-really-fix-integer-overflow-in-swap_show-and-swapon.patch removed from -mm tree
Message-Id: <20261123062521.A57931F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/swapfile: really fix integer overflow in swap_show() and swapon()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-really-fix-integer-overflow-in-swap_show-and-swapon.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: mm/swapfile: really fix integer overflow in swap_show() and swapon()
Date: Wed, 18 Nov 2026 12:26:10 +0100

One of the enterprise customers uses 6 TiB of swap, and the values
reported in /proc/swaps as well as in dmesg are still not correct.

Cast si->pages to long explicitly so that the bitshift in K() doesn't
truncate the value to 32 bits.

Also do the same in swapon() for the same reason.

Link: https://patch.msgid.link/20261118112610.122799-1-oleksandr@natalenko.name
Fixes: 642929a2ded0 ("mm/swapfile: fix an integer overflow in swap_show()")
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: <stable@vger.kernel.org>

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-really-fix-integer-overflow-in-swap_show-and-swapon
+++ a/mm/swapfile.c
@@ -3452,7 +3452,7 @@ static int swap_show(struct seq_file *sw
 		return 0;
 	}
 
-	bytes = K(si->pages);
+	bytes = K((unsigned long)si->pages);
 	inuse = K(swap_usage_in_pages(si));
 
 	file = si->swap_file;
@@ -3968,8 +3968,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
-		K(si->pages), name->name, si->prio, nr_extents,
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+		K((unsigned long)si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(si->flags & SWP_DISCARDABLE) ? "D" : "",
_

Patches currently in -mm which might be from oleksandr@natalenko.name are


