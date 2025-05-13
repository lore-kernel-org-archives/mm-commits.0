Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4E31D6DB4
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119245; cv=none; b=KOXsxdiq6Le/GqjWXGAvi9Ha86CV2OE1Li07bHuWMFRyaiHmg0jk8TXluKqrY6iTK8cDrSEV4zau0HjH98ZyK8Ee6D6AzuF4zaT/2uJnFZP0JRUZEDnX/avlKR1AX5CwXbCR48TOLHHNIqA6duVFXESnef4Q3bVxS0ZXQU7zumg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119245; c=relaxed/simple;
	bh=WKYDYbvpxjraLgQ1S8d5ERw1lgX6MQxuVLnXIiFlnoM=;
	h=Date:To:From:Subject:Message-Id; b=D5YX+gXvseQljGkfeHr/CxI3xg0trd76MYq2+/Zd4cHZsGOEjSguMfRMFGsL5CmeVNRSRHe3MSxqaHTHF5a1NjAt7XcfmSgEmxN5VZztFWXMmkSg8chMdGFZROozYFCUapQtyWZ8DY/wf3oqP33yhWPhg+93LqA0p0I13mJOaAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cUK2AZ4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cUK2AZ4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FDBC4CEE4;
	Tue, 13 May 2025 06:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119244;
	bh=WKYDYbvpxjraLgQ1S8d5ERw1lgX6MQxuVLnXIiFlnoM=;
	h=Date:To:From:Subject:From;
	b=cUK2AZ4zvUINJsO35K5PtXr28KdWDbLbik5MmCMnVzOyDfU5Kq9ADqKf4/tseRD2Q
	 4bDTGeJAAajNZuVlSrdrh6oc3HdyChKEnWYZu0dSFyYM83o5UdoTi5boXZJL3l68KB
	 wZxOirugAwMFMUgpf2hn9QXQh2+bQNVboUX1sqk0=
Date: Mon, 12 May 2025 23:54:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rppt@kernel.org,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,anshuman.khandual@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch removed from -mm tree
Message-Id: <20250513065404.C3FDBC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug_page_alloc: improve error message for invalid guardpage minorder
has been removed from the -mm tree.  Its filename was
     mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/debug_page_alloc: improve error message for invalid guardpage minorder
Date: Sun, 27 Apr 2025 18:04:41 +0800

When an invalid debug_guardpage_minorder value is provided, include the
user input in the error message.  This helps users and developers diagnose
configuration issues more easily.

No functional change.

Link: https://lkml.kernel.org/r/20250427100442.958352-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug_page_alloc.c~mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder
+++ a/mm/debug_page_alloc.c
@@ -23,7 +23,7 @@ static int __init debug_guardpage_minord
 	unsigned long res;
 
 	if (kstrtoul(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
-		pr_err("Bad debug_guardpage_minorder value\n");
+		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
 		return 0;
 	}
 	_debug_guardpage_minorder = res;
_

Patches currently in -mm which might be from liuye@kylinos.cn are


