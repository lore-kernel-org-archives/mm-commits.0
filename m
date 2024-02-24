Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAA74A15
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738073; cv=none; b=eGe8hE9O/4gqRl2l4iy8bXK8xj24NfZHAnXkZ7bBcSjNBxUR5Eqt8f9NKerRPe60Mp/0onn7+OJmJaAVUjO0UuLntWASsx3QjzrGliGJkybygUxX8xktCdu7028BELXJi3Kc11tkpR4dGW5mX9GZKmnZ0QYX7pUSUuF5cPtiG9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738073; c=relaxed/simple;
	bh=p8ymkM0HYKIWtO2M+Nlw8ZsUgtIq+DQi4Mr6p6pefWM=;
	h=Date:To:From:Subject:Message-Id; b=qrxnG9HHenBWFrL8t5YS8MsZedbzKT6iZXDnkfWWlqtfqxFzyoGXlXNPdTaOoquHUEAl3fuiM9/w0BcAC3yGw3p2rITO/ast9Rq3wRb965EwYRCoby2b1XSQHQXwcqEWb9aQAgkYHxX/xQFs/aPq5/HoNtdHprpyiXVW02V/EXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZDRZxvoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZDRZxvoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7AAC43390;
	Sat, 24 Feb 2024 01:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738072;
	bh=p8ymkM0HYKIWtO2M+Nlw8ZsUgtIq+DQi4Mr6p6pefWM=;
	h=Date:To:From:Subject:From;
	b=ZDRZxvoz5/ZrD4vZPNjg2+99suv/LSLyq7ynLqaetixsCcOEaqQENShYaul63sATf
	 lnB9SMkBMTAvAoJ+0SYL5+2nXp2LerUzCZj6/XzUobi6/TMi+/00cdtUqpZ6OLd3Cx
	 hAcU5/TedRfxyzC60C4H2lQdcf0U9whsNxFfvzeo=
Date: Fri, 23 Feb 2024 17:27:52 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,lstoakes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-memory-mapping-entry-with-reviewers.patch removed from -mm tree
Message-Id: <20240224012752.BB7AAC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add memory mapping entry with reviewers
has been removed from the -mm tree.  Its filename was
     maintainers-add-memory-mapping-entry-with-reviewers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: MAINTAINERS: add memory mapping entry with reviewers
Date: Tue, 20 Feb 2024 06:44:10 +0000

Recently there have been a number of patches which have affected various
aspects of the memory mapping logic as implemented in mm/mmap.c where it
would have been useful for regular contributors to have been notified.

Add an entry for this part of mm in particular with regular contributors
tagged as reviewers.

Link: https://lkml.kernel.org/r/20240220064410.4639-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/MAINTAINERS~maintainers-add-memory-mapping-entry-with-reviewers
+++ a/MAINTAINERS
@@ -14111,6 +14111,17 @@ F:	mm/
 F:	tools/mm/
 F:	tools/testing/selftests/mm/
 
+MEMORY MAPPING
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Lorenzo Stoakes <lstoakes@gmail.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/mmap.c
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from lstoakes@gmail.com are


