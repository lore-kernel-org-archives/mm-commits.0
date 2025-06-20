Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28185322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391348; cv=none; b=a3X3Sxb5ayLAbX3I/O1iSAnDTve6e0wCzcSO3ZePsuLjzLuKoV3BjLhfTxniZslE8t2Bt8kjAKbqxlUH6s41f2HwfqrX7eWIbSSBVElmtSjoL5PHcnaI1BaeLzJCj8FObcg0S1jomCUvS5XSZGmLcQcb89e2fB2Rcd5R7pNfakU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391348; c=relaxed/simple;
	bh=VY1HEwZHikBSIpgVfBcCXhqF6oV67FzEkhaxtqCC8hc=;
	h=Date:To:From:Subject:Message-Id; b=WlIpMXOxLbPTeMx+qzY1LXjGopJSPdP+6XIhq8JfgwQ2sFv40/kmdFhcV84zZlUlkw2OZEmoxBnsXX0K9wA57T3x4D3+idiYvyExUOvcDXLC7ZPkLDP5CewmZMedBX+2k7BHqJNm2+F9l7UwChVN90tvzoydQSBwXf9WlUqQa/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pD9Bbspp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pD9Bbspp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A5DC4CEF2;
	Fri, 20 Jun 2025 03:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391347;
	bh=VY1HEwZHikBSIpgVfBcCXhqF6oV67FzEkhaxtqCC8hc=;
	h=Date:To:From:Subject:From;
	b=pD9BbsppunJMcyZq7eO01omsOh0UR+ziM2BadmzOvGvWEZI/gXBerfETumj+yLKJy
	 pYwlQ+qL6qdpMHT5KNoq6cyknVAh8ouzj9gDB+iYQ/VhGPQfkibRPbEdEs5jWTgH53
	 tPjUZ4i+xV3JiNZtqrTRNc0c2z/wJQQeHye6y+eQ=
Date: Thu, 19 Jun 2025 20:49:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ptyadav@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-linux-mm-list-to-kexec-handover.patch removed from -mm tree
Message-Id: <20250620034907.88A5DC4CEF2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add linux-mm@ list to Kexec Handover
has been removed from the -mm tree.  Its filename was
     maintainers-add-linux-mm-list-to-kexec-handover.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <ptyadav@amazon.de>
Subject: MAINTAINERS: add linux-mm@ list to Kexec Handover
Date: Fri, 13 Jun 2025 15:19:14 +0200

Along with kexec, KHO also has parts dealing with memory management, like
page/folio initialization, memblock, and preserving/unpreserving memory
for next kernel.  Copy linux-mm@ to KHO patches so the right set of eyes
can look at changes to those parts.

Link: https://lkml.kernel.org/r/20250613131917.4488-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-linux-mm-list-to-kexec-handover
+++ a/MAINTAINERS
@@ -13347,6 +13347,7 @@ M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Changyuan Lyu <changyuanl@google.com>
 L:	kexec@lists.infradead.org
+L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
_

Patches currently in -mm which might be from ptyadav@amazon.de are


