Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868D234A3D6
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622859; cv=none; b=eSIbtNYUrROOcY7V/7fHSrSwkwCqQHWOhkdPCiCJ+9XA16dQiwcdUIUZl0jkFH/UdQN8sJZerKlm6pu/QC3//slOGySNNLUJsJlj1VOsz5KUd2kv1gnKh1zTq8DMd2lG5bslKWitZsRUALG5FK14ZnjgNaOZPDxyeeBz/0pKPZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622859; c=relaxed/simple;
	bh=sWLza4D0ESwuouKfc81kto+h6N5Jpj2cGASluPaPZNk=;
	h=Date:To:From:Subject:Message-Id; b=ZuEqKoLmUa5vnyNV0pNUoP3BAEPW/ff7z6Zlwa7BJ/7BzgXBmcxxJWmvxhSG+riNte5GtMTUtHdQ1iIsYix+g97vMqxYnui+r2XeDpb1sRBqoFvRZoa83KYdQSXDo5wGgOCAlUJXQffJqkXAEA8Ylk8Sf91WPMgXTQQ0J88yJVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rNZMe9qw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rNZMe9qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF761F000E9;
	Tue, 25 Aug 2026 01:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622858;
	bh=+wFApaa4TboJiSG420RzTtMjqXCwNuqD80XSuyk6gm4=;
	h=Date:To:From:Subject;
	b=rNZMe9qw6sqqYtI7cnQLFPt6lA4PvWz/4EIXZBrDWrdqOljr/yMHtrngmLy9nC88w
	 oZuMxnncG8BJe+u5tGFM37bDO1lk0njLu4xCsYugmg7SW+xPIWUik8PQqRSF89G+wY
	 AR3CQ1c1Vfg7zlmcCHDm0g/S5TYB3vkCsQA5kIdc=
Date: Mon, 24 Aug 2026 18:54:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] correct-__pagemap_scan_get_categories-return-value.patch removed from -mm tree
Message-Id: <20260825015418.5CF761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/vm_util.c: correct __pagemap_scan_get_categories return value
has been removed from the -mm tree.  Its filename was
     correct-__pagemap_scan_get_categories-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm/vm_util.c: correct __pagemap_scan_get_categories return value
Date: Thu, 6 Aug 2026 11:00:34 -0400

Currently __pagemap_scan_get_categories returns the result from the ioctl
call which should be an int, not uint64_t.  The ioctl may return -1 on
error, which will be interpreted as UINT64_MAX.  Adjust the return type to
use the correct value.

Link: https://lore.kernel.org/20260806150339.1824251-2-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~correct-__pagemap_scan_get_categories-return-value
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -34,7 +34,7 @@ uint64_t pagemap_get_entry(int fd, char
 	return entry;
 }
 
-static uint64_t __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
+static int __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
 {
 	struct pm_scan_arg arg;
 
@@ -58,7 +58,7 @@ static uint64_t __pagemap_scan_get_categ
 static uint64_t pagemap_scan_get_categories(int fd, char *start)
 {
 	struct page_region r;
-	long ret;
+	int ret;
 
 	ret = __pagemap_scan_get_categories(fd, start, &r);
 	if (ret < 0)
_

Patches currently in -mm which might be from audra@redhat.com are

selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

