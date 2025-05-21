Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4781632C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806604; cv=none; b=DIWUNDTX5UJkTT5hUk4R8Pf1zY2q9v0QDhSOsF+AZsF/OC5ZcTKlZEenmABAtdXmgz0lDSTLclvtkzfVnEcCbhz+9FyYoKa20YyqSZy/hC9eBMHkWIjd4aHccsJf9y+a8LIpGHPnS5nJsSXt3pdmqmAwUx0pTPavmi5oIWGBdk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806604; c=relaxed/simple;
	bh=tloev9pRq28o1/C3wn6II8B4dINIoaqdAhnjrsyyPmQ=;
	h=Date:To:From:Subject:Message-Id; b=JfCJh4/5pIC+P59LzQJ4DLzi2q0nFuT6v8CX4xj3fFm1xVJREWaoLUOtdcyQ8UJK6c6V3OPg/CtJj91IcqCeXukWtLgO8UBQ+G/mQ8oQS0SkB6tTH0TtcQ/nvrF9sKXYeqJswJ929h45dqoOVWyp11TTaFCoa/7IwqcndrAVoNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kA+EmXBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kA+EmXBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E5FC4CEEB;
	Wed, 21 May 2025 05:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806603;
	bh=tloev9pRq28o1/C3wn6II8B4dINIoaqdAhnjrsyyPmQ=;
	h=Date:To:From:Subject:From;
	b=kA+EmXBx4Plzw+2Ml+LsEdVNulRLAlCsq+t9vbkjboMoFd5d2zgsmzsb9vWwmedHV
	 j1yJ8f5qHgeN1EFkajlVa8de7QAAsFMoUYY+ZVww440izvb0gz16eVoinnsRGQHzAX
	 HmEgS82wnX31KFJNUuk8s9XXhO4QcOJ6pB7Gn9vQ=
Date: Tue, 20 May 2025 22:50:03 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,hch@infradead.org,david@redhat.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-myself-as-vmalloc-co-maintainer.patch removed from -mm tree
Message-Id: <20250521055003.A9E5FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add myself as vmalloc co-maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-vmalloc-co-maintainer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: MAINTAINERS: add myself as vmalloc co-maintainer
Date: Wed, 7 May 2025 17:02:57 +0200

I have been working on the vmalloc code for several years, contributing to
improvements and fixes.  Add myself as co-maintainer ("M") alongside
Andrew Morton.

Link: https://lkml.kernel.org/r/20250507150257.61485-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-myself-as-vmalloc-co-maintainer
+++ a/MAINTAINERS
@@ -25906,7 +25906,7 @@ F:	tools/testing/vsock/
 
 VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Uladzislau Rezki <urezki@gmail.com>
+M:	Uladzislau Rezki <urezki@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from urezki@gmail.com are


