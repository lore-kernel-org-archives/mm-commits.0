Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160E621518B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188237; cv=none; b=prHYHwsXB+wtNGiLNThg8i+XBVoHW9JsZKyG2cimluRTuCnuJbYlEAdQ0KsNOpuSkii2bjD/PvubjxmG8o3cpzN5NXGhQNfCFurI8/Ce11hOP3VVzDxXmSfN44BtaM4//Bj/CFJKPIR18N+xfD+DLTA16d53GX4el73ivSmW1B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188237; c=relaxed/simple;
	bh=pA1lL9SzyDUrm8eFfwVmA83RUoAk9RXOpYhnogN/wH0=;
	h=Date:To:From:Subject:Message-Id; b=jPwSZQo2gTjFrHgEkOCRUjISN33CWIwoJu1Pj3+jQfeEt5s5IXKMqXBgamKjpnuhiwYjBwGMyGeybI9cQ8NS8Jcd7u/t5TJW094LLq5zfPelBdUpxF2S9KrlaVuiFNzYEWeIw+DBY5aNDESEHsiK8fG9jz6VnDLabpf2fpIFPf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g3GSK4rK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g3GSK4rK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B1AC4CEEC;
	Mon, 17 Mar 2025 05:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188236;
	bh=pA1lL9SzyDUrm8eFfwVmA83RUoAk9RXOpYhnogN/wH0=;
	h=Date:To:From:Subject:From;
	b=g3GSK4rKtl3K7J84eqTT4+Llhe2JaqcN/ORHU5a8V4Wtd5SxPm8b2i/ijnUEMNDMP
	 AHP8ibx6EqeQhuwrvqgaUxkT+99CdVQfbKAIfSOi5emW7hdg2rrhEfCi25lo55HkI4
	 9HZTWYQ9UbGZauuStI6eI+IBUptcAZGSWHpb6fqo=
Date: Sun, 16 Mar 2025 22:10:35 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch removed from -mm tree
Message-Id: <20250317051036.82B1AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_state.c: optimize the code in clear_shadow_from_swap_cache()
has been removed from the -mm tree.  Its filename was
     mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap_state.c: optimize the code in clear_shadow_from_swap_cache()
Date: Wed, 5 Feb 2025 17:27:11 +0800

Use ALIGN to achieve the same effect and simplify the code.

Link: https://lkml.kernel.org/r/20250205092721.9395-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache
+++ a/mm/swap_state.c
@@ -270,9 +270,7 @@ void clear_shadow_from_swap_cache(int ty
 		xa_unlock_irq(&address_space->i_pages);
 
 		/* search the next swapcache until we meet end */
-		curr >>= SWAP_ADDRESS_SPACE_SHIFT;
-		curr++;
-		curr <<= SWAP_ADDRESS_SPACE_SHIFT;
+		curr = ALIGN((curr + 1), SWAP_ADDRESS_SPACE_PAGES);
 		if (curr > end)
 			break;
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are


