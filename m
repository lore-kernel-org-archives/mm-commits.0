Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2911C6FF8
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274655; cv=none; b=g3wv7sfBwEenX6Wuazd6tsG1smtq3w1+ReGcLdC2E9ZNPm6dggzkYhYIcEY2y+MuvL6Ja43fYnI7pLrfUgcwr6ujrm+61kvV0NAb3wjjMq+9PY+31kO5ZhKxvmZ0LNqekLMdGZt9Em8DD421Z6EUSqrMj/w3jQSHoK++2TNcYts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274655; c=relaxed/simple;
	bh=Gyg5NvScp3xDKlLG82YyiwbC/ADBe4s1ImDpy5SJl2E=;
	h=Date:To:From:Subject:Message-Id; b=Uk7xQ7hi5Nn6D2csVoQvCD21dnowKJU/fqetyHpnclh1TThdNzFavcIYFPgtypl5Sx0WsOCOX2cnvnIL9gqcITIOsPTjr+u2aZtzNZ/gSsEvEMo4TPTgGFgQPDopq48x/OLCgKldiT2wQ1BdyuhmzYyAHkGtVGUvG9UrNqQnGOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OH/5KVkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OH/5KVkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86098C4CEDD;
	Tue, 18 Mar 2025 05:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274655;
	bh=Gyg5NvScp3xDKlLG82YyiwbC/ADBe4s1ImDpy5SJl2E=;
	h=Date:To:From:Subject:From;
	b=OH/5KVkQ1p1uFTL/bLy4f9H74aC4f2wwyleRF3DfLmzo0In7HO76uWgiZGvE23YKQ
	 cbIxwGlX+s6AfCcBWOOneMnNf6otphHgWsQOpPPacBNEvsIHvjNNWaqNSyzA1o0QMg
	 x7zI/COIeEVgGOpNQI9cfdOs0EaDoULwQ86ZBwNg=
Date: Mon, 17 Mar 2025 22:10:55 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-adjust-file-entry-in-maple-tree.patch removed from -mm tree
Message-Id: <20250318051055.86098C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: adjust file entry in MAPLE TREE
has been removed from the -mm tree.  Its filename was
     maintainers-adjust-file-entry-in-maple-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: MAINTAINERS: adjust file entry in MAPLE TREE
Date: Wed, 12 Mar 2025 11:52:45 +0100

Commit 0f3b602e1bad ("tools: separate out shared radix-tree components")
moves files from radix-tree/linux to shared/linux in the ./tools/testing/
directory, but misses to adjust a file entry in MAPLE TREE.  Hence,
./scripts/get_maintainer.pl --self-test=patterns complains about a broken
reference.

Adjust the file entry in MAPLE TREE.

Link: https://lkml.kernel.org/r/20250312105245.216302-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-adjust-file-entry-in-maple-tree
+++ a/MAINTAINERS
@@ -13922,8 +13922,8 @@ F:	include/linux/maple_tree.h
 F:	include/trace/events/maple_tree.h
 F:	lib/maple_tree.c
 F:	lib/test_maple_tree.c
-F:	tools/testing/radix-tree/linux/maple_tree.h
 F:	tools/testing/radix-tree/maple.c
+F:	tools/testing/shared/linux/maple_tree.h
 
 MARDUK (CREATOR CI40) DEVICE TREE SUPPORT
 M:	Rahul Bedarkar <rahulbedarkar89@gmail.com>
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are


