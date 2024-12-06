Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C8918CBFE
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 03:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457337; cv=none; b=qEgdVE1H/h8I+Qv+oycbo9ZWbI/jEbUUDK146osPduaMcUU7ClOrWFa8PausG5U3z56phEPgnhcfk2MQfTCSYgxDb9UbaJRN+nnBNgWVYulk3VMAMrmZqcB9RoSnGYintaDW8YMJyhJg7iwt80+Q7wBh8HML6TGvAavyTDhtiK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457337; c=relaxed/simple;
	bh=kM1C61kEGWFnlionK4AYTY3ukiFYlqGoQQhM1uSQCmE=;
	h=Date:To:From:Subject:Message-Id; b=liJn7JYFE0Gq/3UDkssi+/qPuJht0LertvDNyGMsBXW+i2ixZxXdu0WIRKa7kUlQ3MSVjoh5BNqc8yq4vkamjjSZoMjXi2QghVv/WHQcsdYsrQ2Km7mGkq+VcZoeRRwDITxoWPrt9Rb1yRflroEx2zAq0AU9rD1pz8EzOvLuPZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jBq7Nlhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jBq7Nlhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14119C4CED1;
	Fri,  6 Dec 2024 03:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457337;
	bh=kM1C61kEGWFnlionK4AYTY3ukiFYlqGoQQhM1uSQCmE=;
	h=Date:To:From:Subject:From;
	b=jBq7NlhbxJQ7NcBIhZr50fOI/P+UJkVZ3AHAVlfsQDjd9juefKVjM9OjdMgzXlJES
	 VnwcEFTAq4eBYtUjtdn+zokaV0CyWC0PNX4+J6pCZyHP1Fp1UVEOWP0rNm4VPn/V+U
	 5axLrQLCSjNsybgGCFAx71Ibge7CTXiuOQcuhOvA=
Date: Thu, 05 Dec 2024 19:55:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hdanton@sina.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch removed from -mm tree
Message-Id: <20241206035537.14119C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: don't call folio_test_locked() without a reference in next_uptodate_folio()
has been removed from the -mm tree.  Its filename was
     mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/filemap: don't call folio_test_locked() without a reference in next_uptodate_folio()
Date: Fri, 29 Nov 2024 13:53:03 +0100

The folio can get freed + buddy-merged + reallocated in the meantime,
resulting in us calling folio_test_locked() possibly on a tail page.

This makes const_folio_flags VM_BUG_ON_PGFLAGS() when stumbling over the
tail page.

Could this result in other issues?  Doesn't look like it.  False positives
and false negatives don't really matter, because this folio would get
skipped either way when detecting that they have been reallocated in the
meantime.

Fix it by performing the folio_test_locked() checked after grabbing a
reference.  If this ever becomes a real problem, we could add a special
helper that racily checks if the bit is set even on tail pages ...  but
let's hope that's not required so we can just handle it cleaner: work on
the folio after we hold a reference.

Do we really need the folio_test_locked() check if we are going to trylock
briefly after?  Well, we can at least avoid a xas_reload().

It's a bit unclear which exact change introduced that issue.  Likely, ever
since we made PG_locked obey to the PF_NO_TAIL policy it could have been
triggered in some way.

Link: https://lkml.kernel.org/r/20241129125303.4033164-1-david@redhat.com
Fixes: 48c935ad88f5 ("page-flags: define PG_locked behavior on compound pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+9f9a7f73fb079b2387a6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/674184c9.050a0220.1cc393.0001.GAE@google.com/
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio
+++ a/mm/filemap.c
@@ -3501,10 +3501,10 @@ static struct folio *next_uptodate_folio
 			continue;
 		if (xa_is_value(folio))
 			continue;
-		if (folio_test_locked(folio))
-			continue;
 		if (!folio_try_get(folio))
 			continue;
+		if (folio_test_locked(folio))
+			goto skip;
 		/* Has the page moved or been split? */
 		if (unlikely(folio != xas_reload(xas)))
 			goto skip;
_

Patches currently in -mm which might be from david@redhat.com are

docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch

