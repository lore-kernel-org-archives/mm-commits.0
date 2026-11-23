Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415097;
	b=MGXICEd6Vh0jtw4oP4g6+B9PhHVp/F59LCY3irGBwBQ7oRISR/qzs5rfIheuNF1JPPdL
	 hmShcIHay5Hz89cUMugxZdK0ryEyrdDdg60HPH5C2WlXkYqkUyPBdLkYebBZe/MyK8D1l
	 KEWJrXJY7cdpNBT8nSHNumUQ09m6YjllrNxe/fnXAcZo+2abdCWSDAYnXIvXV4uj9acLL
	 /9M4ZcMy7aQ+0h7jevCLoQgF7hKvhQLsSpHvIv45WuOkvUI/cudkEK4CXYyFWH1w63AKm
	 jHoeRnU7Jgap//qMew7rmhp3vg/8Eysq2uajbHPplWiOS+hOSr+/Liu4HSkzUOsAQAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415097;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=JCxxI6nvOGyyxW9P605GmDTJsANdBwTJMF0mYx3uUe4=;
	b=NBLPLg03wErbLOK/uGc4HFr7itIK4CNg8287kHUKG7BuSGYcUEh3B3AAbQoQOP3p8o8r
	 P64+gaYo3178bW9Swa5wQOuplACbsTKX1crsOStUZ1s18j7Fc4ybPNZscIRlR3HPlyA/9
	 6oBQyGGfUXIrcki9JGIQeOytrPrL38TO+16kSoHL0OPQkcRyD+k9xsveYuCo6H2BnhofK
	 5d5fsah0Rv/GMZcgpB1lva/oMqu8SPDv3OK2ozJL1I7WLJ177u9NYtm5VvYQXkOc/azGr
	 EO3tX2s1F7+IG/l2/kuaICCXIezMeYL+tuS0uvxaw0j0thVcl+GTtcG0FJPhWY5nLYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oPSdynHm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582EE606A321
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 06:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oPSdynHm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B1D1F000E1;
	Mon, 23 Nov 2026 06:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415096;
	bh=JCxxI6nvOGyyxW9P605GmDTJsANdBwTJMF0mYx3uUe4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=oPSdynHmQ0zW61NKYU69jfisz0C1Z1Et/Skyz26c5eduyNL36Hsz75qOvLrpDdBMA
	 VHN270m2KjekmdkabLtmJndSz+SaZeBfvatK2Nm2VZykhp/QGALPF6Yn2pXofxDyfR
	 yytSFu46z2J3DupMO5ete0HgeMlwo8mVyVAj9FEk=
Date: Sun, 22 Nov 2026 22:24:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,work@onurozkan.dev,
	vbabka@kernel.org,usama.arif@linux.dev,urezki@gmail.com,tmgross@umich.edu,
	tamird@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,
	ryan.roberts@arm.com,rppt@kernel.org,qi.zheng@linux.dev,ojeda@kernel.org,
	nico.pache@linux.dev,mhocko@suse.com,lossin@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,gary@garyguo.net,
	dev.jain@arm.com,david@kernel.org,daniel.almeida@collabora.com,
	dakr@kernel.org,boqun@kernel.org,bjorn3_gh@protonmail.com,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,aliceryhl@google.com,
	a.hindborg@kernel.org,acourbot@nvidia.com,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261110-drop-reviewerships-v1-4-07c2f06e8dfa@kernel.org>
References: <20261110-drop-reviewerships-v1-4-07c2f06e8dfa@kernel.org>
Subject: [merged mm-hotfixes-stable] credits-add-entry-for-thp-maintenance.patch removed from -mm tree
Message-Id: <20261123062456.A3B1D1F000E1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: CREDITS: add entry for THP maintenance
has been removed from the -mm tree.  Its filename was
     credits-add-entry-for-thp-maintenance.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: CREDITS: add entry for THP maintenance
Date: Tue, 10 Nov 2026 12:03:10 +0000

Given my workload and current areas of focus, I think it's unlikely I will
return to THP, so add a CREDITS entry to reflect my time as co-maintainer
there.

With Zi being appointed as an absolutely worthy successor as THP
co-maintainer I am confident in its success, and this additionally makes me
feel that it is unnecessary for me to return (for the best possible
reasons!)

Link: https://patch.msgid.link/20261110-drop-reviewerships-v1-4-07c2f06e8dfa@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Benno Lossin <lossin@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Tamir Duberstein <tamird@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Onur Özkan <work@onurozkan.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>

 CREDITS |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/CREDITS~credits-add-entry-for-thp-maintenance
+++ a/CREDITS
@@ -3939,6 +3939,12 @@ D: mandocs and mandocs_install build tar
 S: (Email me and ask)
 S: Australia
 
+N: Lorenzo Stoakes
+E: ljs@kernel.org
+W: https://ljs.io
+D: THP co-maintainer
+S: UK
+
 N: Henrik Storner
 E: storner@image.dk
 W: http://www.image.dk/~storner/
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch

