Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA5F351C1E
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338670; cv=none; b=NFSRb4w+3xdbUct95y8J39cjr+WxBaGsOmAO1jP3bYXsiTIR0hPPpKKXwcU6yBdS8iKCVSrqOpdCzRMm7dTz73AWA/cjc3JqgIABN7WtfBwjQThcsmQVYDPVdlztQ7pBWgOX8w5Jt1N3vdyICgHaHQoKsxAumG57MBE8qp/dJUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338670; c=relaxed/simple;
	bh=0elMq1hVN0Wjm/zBbFOyizlOBjmIPqre/sHG5nJgHFM=;
	h=Date:To:From:Subject:Message-Id; b=eKvKvBOZzw0Ng5Ad6rThalgJ08Z8J2wlJGcdABAyHmUWcI+aNbduru6V7Sw1x3ZNkJfECB7VjD50SGMAuHt/C4cY13vppzsJJHZ5BSJTg/8noe1rzka6n23fOvPj4fQdqMqLkrwWc4Rq5Q4orYCu6Qvj80c0bDNaBZ6ULa84a8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OylXD1L5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OylXD1L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DA71F0089C;
	Wed,  7 Oct 2026 02:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338669;
	bh=Y2d9qq426f4H9N3XKwcczOlvZAOQEgHZmsupfLlP8Vo=;
	h=Date:To:From:Subject;
	b=OylXD1L5Coji34ij0cAF4lafOakDJwOgahORC3mNu/D9LRJVCTbJdmo63cepSNFSW
	 +wN5/QTbYfuExj7PdEkfd/+u7nmQZqzpPrfaHjcQhZ9c1Il3MafCvon0bozkfaWO90
	 LsUEwGgdPu1uta7pE2BhmVR16//S5NGI1d0Lbc+Y=
Date: Tue, 06 Oct 2026 19:04:29 -0700
To: mm-commits@vger.kernel.org,oberpar@linux.ibm.com,brads@mainlining.org,hrushirajg23@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] gcov-use-strscpy-instead-of-strcpy-in-init_node.patch removed from -mm tree
Message-Id: <20261007020429.70DA71F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gcov: use strscpy() instead of strcpy() in init_node()
has been removed from the -mm tree.  Its filename was
     gcov-use-strscpy-instead-of-strcpy-in-init_node.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hrushiraj Gandhi <hrushirajg23@gmail.com>
Subject: gcov: use strscpy() instead of strcpy() in init_node()
Date: Mon, 31 Aug 2026 20:19:53 +0530

node->name is a flexible array member sized to exactly strlen(name) + 1
bytes at allocation time in new_node(), so this copy can never actually
overflow.  Still, prefer the bounded strscpy() over strcpy() on general
principle; pass the same strlen(name) + 1 bound the allocation used, since
sizeof() cannot be applied to a flexible array member.

No functional change.

Link: https://lore.kernel.org/20260831144953.324441-1-hrushirajg23@gmail.com
Signed-off-by: Hrushiraj Gandhi <hrushirajg23@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
---

 kernel/gcov/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/gcov/fs.c~gcov-use-strscpy-instead-of-strcpy-in-init_node
+++ a/kernel/gcov/fs.c
@@ -529,7 +529,7 @@ static void init_node(struct gcov_node *
 	}
 	node->parent = parent;
 	if (name)
-		strcpy(node->name, name);
+		strscpy(node->name, name, strlen(name) + 1);
 }
 
 /*
_

Patches currently in -mm which might be from hrushirajg23@gmail.com are


