Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0FF14430B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291708; cv=none; b=hGjG3YfEf7pbGHhuiIE3WgMdVPGZ/MnG5JPEI2+ZtgHi5+mjhdqyHJUqCW7yqe20oPjMQVISwxjElC5QHHf2huuCRWZNAsDKdYrRUH3VtQyxIhgfa4NfIJBhhIAJ28XfHjp2NUcm5iTzpdCtC8wEZtihw/urZGPl0BkCPmrvRo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291708; c=relaxed/simple;
	bh=2+iruvqNClJ2UADEbtMvn96YNavOE2dTp5+cujXE4yk=;
	h=Date:To:From:Subject:Message-Id; b=No3pA7m63s63SCTThXHmIPt/JJsUP1DutEogM0vsfawX8EcLh/A9nGK37HEGhO1+JJtsOjQHw0Tlm2zM7UqZyqzr+cwoxzs75Zxe8kR8aLeoxvidGhHER9QtdeqQuHf9EJLQF23+pFuX0bTk9mcLlt/XA+hVlofCYme13/QfEMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HkXIyPl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HkXIyPl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1210C32789;
	Tue, 25 Jun 2024 05:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291707;
	bh=2+iruvqNClJ2UADEbtMvn96YNavOE2dTp5+cujXE4yk=;
	h=Date:To:From:Subject:From;
	b=HkXIyPl3+x7X59OmqmnyEH5RxV1j0sy0UNlpGuN0PJq2NJ/WDdfqUXW661T91Djkh
	 27KfSc9gr3D6oWhQJEDxQm+758mpyxb3SVlBb1l+m1cdKmhE8XXGptfra++4qRO900
	 Kdv6SPEaUyB7tgV8IzP8BsBdliAL6ZWpE3R6sdzU=
Date: Mon, 24 Jun 2024 22:01:47 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-add-macro-get_page_max_retry_num.patch removed from -mm tree
Message-Id: <20240625050147.C1210C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: add macro GET_PAGE_MAX_RETRY_NUM
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-macro-get_page_max_retry_num.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: add macro GET_PAGE_MAX_RETRY_NUM
Date: Wed, 12 Jun 2024 15:18:25 +0800

Add helper macro GET_PAGE_MAX_RETRY_NUM to replace magic number 3.  No
functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-add-macro-get_page_max_retry_num
+++ a/mm/memory-failure.c
@@ -1417,6 +1417,8 @@ static int __get_hwpoison_page(struct pa
 	return 0;
 }
 
+#define GET_PAGE_MAX_RETRY_NUM 3
+
 static int get_any_page(struct page *p, unsigned long flags)
 {
 	int ret = 0, pass = 0;
@@ -1431,12 +1433,12 @@ try_again:
 		if (!ret) {
 			if (page_count(p)) {
 				/* We raced with an allocation, retry. */
-				if (pass++ < 3)
+				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 					goto try_again;
 				ret = -EBUSY;
 			} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
 				/* We raced with put_page, retry. */
-				if (pass++ < 3)
+				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 					goto try_again;
 				ret = -EIO;
 			}
@@ -1462,7 +1464,7 @@ try_again:
 		 * A page we cannot handle. Check whether we can turn
 		 * it into something we can handle.
 		 */
-		if (pass++ < 3) {
+		if (pass++ < GET_PAGE_MAX_RETRY_NUM) {
 			put_page(p);
 			shake_page(p);
 			count_increased = false;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


