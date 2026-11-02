Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793596656;
	b=LdV+9hBgTUbzjWEmMJrRkIQpaDrVlACKEPf/h5s/Gi26K0CQirbOzmSMSibjhbjLOVY1
	 eGowWm/AH/DaRoAAnDqinlzDxPWE0c+ZVZmrF+WW8g1DReTUPGpAYhmKk87AZs3mkvUa8
	 ITM8BSYZX7JtT5NMVIFDap2XzvWDiqCCCyOoakuHbzYjQ6K69fhINa+PA+v+3tyWLBa7O
	 l9dxmvo7DumVHZsnbbmYTj0rXc8GAhrvcOLoZ1SD8ZVg8ePbfWvfdRxHLO6l5R+mJrEt2
	 bsjD2fDoDOl26dU2oVVVOOSz63bSdJgDsggebWWUV7VCjllS8r4vC7RqcTTrKiGed6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793596656;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=k2OW/L+2s6UQKv44UbDz1KeQIYIeeO7TemYvOkegiCc=;
	b=Nt7MaIioemxTb4iGch3RuUptczI0WEvvUwjDgYoLz7i2TF3wyXwt4QdjGQVHF2F0oCTu
	 qgqUE5GyMEm/q3oyYnPHiihKIkq82J/+HPddPjb6fa5LIE9jfpyT9XZ4iMPvts11IlQE+
	 Jp02YrZF7zON5X2E5obdRoUai0z3ZPjMANtSMOVTXPEIsH/AnbyCGggrFMB+xH1gN0my0
	 chd06L/fvMO98mmCKFLYJcvrXacysgi5LpnLRO1br8EzCTNq/UdrhrrHANs4m5DCTixwF
	 spzomvq5OLhpALoo5ZDuuCmunxeAkMpW2dVHOtw0P/xsTHFpK0asNWGqi0JQ3jJGkpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rFyQJeHB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ABB606A326
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 05:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rFyQJeHB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4411F000C1;
	Mon,  2 Nov 2026 05:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793596655;
	bh=k2OW/L+2s6UQKv44UbDz1KeQIYIeeO7TemYvOkegiCc=;
	h=Date:To:From:Subject;
	b=rFyQJeHBoI9pF/n6oCuTrWxz/hHQTVpYoeQTtAGXZ8E0B5tbibUC6K5RcDLmQExO/
	 OBYk5O6BH7ZHiRgzp5VDSov5IBpEWGxzPm12ANWmkxLN47JfvMmyQ4RFO30t2n+Ec+
	 AGOWDa/c+VhQ4yqVGy5MT/8H14v/nhLRiS7d6Syg=
Date: Sun, 01 Nov 2026 21:17:35 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,tongweilin@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-thpmaps-fix-missing-mapping-names.patch added to mm-new branch
Message-Id: <20261102051735.8C4411F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/mm/thpmaps: fix missing mapping names
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-thpmaps-fix-missing-mapping-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-thpmaps-fix-missing-mapping-names.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Weilin Tong <tongweilin@linux.alibaba.com>
Subject: tools/mm/thpmaps: fix missing mapping names
Date: Tue, 27 Oct 2026 15:49:04 +0800

VMAList splits smaps lines on whitespace and only keeps the mapping
name when there are exactly six fields. Names containing whitespace,
including paths with a (deleted) suffix, are therefore lost.

Limit splitting to the five fixed fields and preserve the remaining
name.

Link: https://lore.kernel.org/20261027074904.3328878-4-tongweilin@linux.alibaba.com
Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 tools/mm/thpmaps |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/thpmaps~tools-mm-thpmaps-fix-missing-mapping-names
+++ a/tools/mm/thpmaps
@@ -198,7 +198,7 @@ class VMAList:
         self.vmas = []
         with open(f'/proc/{pid}/smaps', 'r') as file:
             for line in file:
-                elements = line.split()
+                elements = line.rstrip('\n').split(maxsplit=5)
                 if '-' in elements[0]:
                     start, end = map(lambda x: int(x, 16), elements[0].split('-'))
                     major, minor = map(lambda x: int(x, 16), elements[3].split(':'))
_

Patches currently in -mm which might be from tongweilin@linux.alibaba.com are

tools-mm-thpmaps-fix-partial-thp-anon-file-accounting.patch
tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics.patch
tools-mm-thpmaps-fix-missing-mapping-names.patch

