Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4986627FE
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255710; cv=none; b=b4TvMjDjeKtQ7aaoVAPDlE+KlcPwGpJJClV5XWvSnftUEDt9zIUpEEdDn5BzjK9tiDUSW3xmxn7FALI3ff3xNDTXZNeavpqxC88HJDXzvm0H0vfXVKiQQQPcoFeZ2wQpG0BiHrxqDl0FVZ9JxXUqBNMZpZ9xuoufXlYbYWZ1dCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255710; c=relaxed/simple;
	bh=+eQV0IO/Pa08P0xiSRmY/KMbq7AV1vHqAB2mqv2sJn0=;
	h=Date:To:From:Subject:Message-Id; b=Uhk3db8zF/WKTczL9026ex3bWLpIc3DyiqZVrduiBPZwsK9XE5WkVMV6m6UmaoQ+dU4s7H5q4r0mybY8J+5Lq6C4dClMPlohSkfZ2egD982zipTvMeOC5844P5cM2UlCUdkMeMtoJiQ29OGRnKkWQLYvQlG5OQ1BhSt3/9uf9WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gbQBoLEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gbQBoLEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5ECC433C7;
	Fri, 26 Jan 2024 07:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255710;
	bh=+eQV0IO/Pa08P0xiSRmY/KMbq7AV1vHqAB2mqv2sJn0=;
	h=Date:To:From:Subject:From;
	b=gbQBoLEz2rYw5idHnKTqbYE83TK7YLRC6aAkNC3TaQCOIsZQcNe2mE0hw5EYfnOPN
	 Drg36NGO0tuHTCAKuSU0FPfC10JabV7qrYHWtiRL7NcbnkI+tGCCmEopSMYUaQfEqI
	 /65AMycJ9qKLrkU1Kxf5NRKI3qhm6n6lpkbWTaOU=
Date: Thu, 25 Jan 2024 23:55:07 -0800
To: mm-commits@vger.kernel.org,alx@kernel.org,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-man-pages-git-trees.patch removed from -mm tree
Message-Id: <20240126075509.CE5ECC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add man-pages git trees
has been removed from the -mm tree.  Its filename was
     maintainers-add-man-pages-git-trees.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: MAINTAINERS: add man-pages git trees
Date: Wed, 17 Jan 2024 13:22:57 +0100

The maintainer uses both.

Link: https://lkml.kernel.org/r/20240117122257.2707637-1-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Alejandro Colomar <alx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-man-pages-git-trees
+++ a/MAINTAINERS
@@ -12902,6 +12902,8 @@ M:	Alejandro Colomar <alx@kernel.org>
 L:	linux-man@vger.kernel.org
 S:	Maintained
 W:	http://www.kernel.org/doc/man-pages
+T:	git git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
+T:	git git://www.alejandro-colomar.es/src/alx/linux/man-pages/man-pages.git
 
 MANAGEMENT COMPONENT TRANSPORT PROTOCOL (MCTP)
 M:	Jeremy Kerr <jk@codeconstruct.com.au>
_

Patches currently in -mm which might be from pvorel@suse.cz are


