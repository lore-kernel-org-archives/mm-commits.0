Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE981A08CA
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011146; cv=none; b=tzPYz8FSU+8s3WLerPTCWyCXY8GytN66dd9dON3PAa/UT8LC990OZ9DoJRgoZrR8efk9bURW4q71uu3cj2JgVDcu0tCpNYbhZKiQiFvUrv6TpzKQvuZl2WTmGeEU3xdPxGpjAlU2py/y1POafmoDRCyAn/utgEteDDfGmna/olY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011146; c=relaxed/simple;
	bh=enXC9k3opEJ+aMktOXdJNeaPpvUQcbHTZWErERAgf8k=;
	h=Date:To:From:Subject:Message-Id; b=N+JkqV/U3gkkCNkpOaqLn2fz7VVRWQT2acnQCMh87S67/Brdgt99RfBj/Oj3Vdvi2jeW+CPkTKcYO72yLtbgwgQZZN/jX93X16ILfR8nI5BRIi4zin3oNAX1V9d9/f78ZwdmdXwynSo2JD0KqLiQWwhWMYdFonTzXxUH8N2cI3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Aq9lK6S3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Aq9lK6S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81968C4CEE4;
	Mon, 12 May 2025 00:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011146;
	bh=enXC9k3opEJ+aMktOXdJNeaPpvUQcbHTZWErERAgf8k=;
	h=Date:To:From:Subject:From;
	b=Aq9lK6S3ejqnIkr7aOQ9CY4aUMViUir14huT9geQ9IbumzJ0Xhj0ic0+kWwgJUyMx
	 hlIPx3rr2tWkBssXNu1yoi03vmpOsQW5EnGBfWJF0T2QumewmXnyn0husiiYGoND8z
	 /VQHvEDKFYQlzNOj5jwKZdkqZ20NtLNpcaA2COv4=
Date: Sun, 11 May 2025 17:52:26 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-test_vmallocc-to-vmalloc-section.patch removed from -mm tree
Message-Id: <20250512005226.81968C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add test_vmalloc.c to VMALLOC section
has been removed from the -mm tree.  Its filename was
     maintainers-add-test_vmallocc-to-vmalloc-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: MAINTAINERS: add test_vmalloc.c to VMALLOC section
Date: Thu, 17 Apr 2025 18:12:15 +0200

A vmalloc subsystem includes "lib/test_vmalloc.c" test suite.  Add an "F:"
entry under VMALLOC section to track this file as part of the subsystem.

Link: https://lkml.kernel.org/r/20250417161216.88318-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-test_vmallocc-to-vmalloc-section
+++ a/MAINTAINERS
@@ -25927,6 +25927,7 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
 F:	mm/vmalloc.c
+F:	lib/test_vmalloc.c
 
 VME SUBSYSTEM
 L:	linux-kernel@vger.kernel.org
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch

