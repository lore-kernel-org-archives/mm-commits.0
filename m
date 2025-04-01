Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68D21EFF8B
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545886; cv=none; b=AqgxlJ0BB+3IipCIAY8H/+joJ3VcxWa27RFxltQion3hY6/IWD6kTqkfOZOYHfj+qjcbO+vs729SKrIrVhrqXW9/T5WAU0AMTJGme1H1bhsUaYUOeYG4BtLsOxL4JMEBzgLY+8oicX7UCYN3q9a5ETb5fOlvyrxgs40ppY4fai0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545886; c=relaxed/simple;
	bh=TzSTXjRRn0EehHBrj7O/AIBBtRTlRsLX98d6W4MrHCc=;
	h=Date:To:From:Subject:Message-Id; b=SE4GTfa/+flM+60Gfc+52fJn13OZYlyRE4fX0ZybEVnXzJ+fIWE/+ADgvbWELoh4jBJTGY4s1ZIO2gioVlGdZiSIXMkPlR3l7nnZgQKzsIFI80w6TMvQ/ETA7O51svW/ksgndB7tbvKB7kgYAfAW0zzdQJIVfwupXHaP798yGmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vXtDLaxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vXtDLaxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8D2C4CEE4;
	Tue,  1 Apr 2025 22:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545886;
	bh=TzSTXjRRn0EehHBrj7O/AIBBtRTlRsLX98d6W4MrHCc=;
	h=Date:To:From:Subject:From;
	b=vXtDLaxzDWiYaAwOsS3bwTxaNTdSs6nAgj4/wFqX+ueVbqAKEfd3SCLMjDsBI3l6Z
	 Ts27YcDYEcrIOIa3C1crniS7Rx6DyTKLhMcvPgIwoNdE6r1OHv08XHREy+Q369z8+K
	 P7oWcXfhypm4atsYX7cN4QyqUejscHT4HJDtX/jo=
Date: Tue, 01 Apr 2025 15:18:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,osalvador@suse.de,mhocko@suse.com,dan.j.williams@intel.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-mm-add-entry-for-execmem.patch removed from -mm tree
Message-Id: <20250401221806.8B8D2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mm: add entry for execmem
has been removed from the -mm tree.  Its filename was
     maintainers-mm-add-entry-for-execmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: mm: add entry for execmem
Date: Wed, 26 Mar 2025 23:55:39 +0200

Link: https://lkml.kernel.org/r/20250326215541.1809379-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS~maintainers-mm-add-entry-for-execmem
+++ a/MAINTAINERS
@@ -15497,6 +15497,14 @@ F:	tools/mm/
 F:	tools/testing/selftests/mm/
 N:	include/linux/page[-_]*
 
+MEMORY MANAGEMENT - EXECMEM
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Mike Rapoport <rppt@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/execmem.h
+F:	mm/execmem.c
+
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
_

Patches currently in -mm which might be from rppt@kernel.org are


