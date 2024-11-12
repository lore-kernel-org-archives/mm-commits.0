Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935F6204952
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374586; cv=none; b=OtacctijMEMN2Gn/+SRM2GPXMDEi9+rLD01zshqvrUp4gOsBHVPfQZJGtQjH/mNQLXpyjTzeA1Ag+4IQenWhCrLxz2W0rnqz8J6JYy9W4baFlyBGEyHLEk0cJcDyKatEho3oEPHuRPVYhLkC7nyK+j2RXLuLn/Zk5xvXn1regr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374586; c=relaxed/simple;
	bh=osQsaTF1QHxIxwCxp3SgIdpbU5aZyhlwLO/0/P7InkQ=;
	h=Date:To:From:Subject:Message-Id; b=bKyuB/K8pTcLulOmKrk7ANU17Y8VXeLKmfvuP16hKr1w4zYXvL5LtN/cXn9XjtnwksVFmUymHE/9wYSp7XPocqrhF0ymQ9dJmmzp+7QFl8xGKtcRVSETi+O6ycuG7CmTwkww1dmxCMo+LPiczBH52R7buang0wmme9TrgwqZ4SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BGMwquSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BGMwquSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFEDC4CECF;
	Tue, 12 Nov 2024 01:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374586;
	bh=osQsaTF1QHxIxwCxp3SgIdpbU5aZyhlwLO/0/P7InkQ=;
	h=Date:To:From:Subject:From;
	b=BGMwquSwwBX1RRG2e7/YJvp9kFK3wjKWFAVrUhnrm8gERCfclTudWwmNPC9jOyvql
	 03VP72ERAlp2BIA+u0ghnvkc96U+AxnfJaolCNh1HQRr0C43wJ0QJxZN9beaSFGaJW
	 22GxzzRysFso3YjPHDIQ2EILybhu50RIhdY5R4Lk=
Date: Mon, 11 Nov 2024 17:23:05 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-memory-management-add-document-files-for-mm.patch removed from -mm tree
Message-Id: <20241112012306.1AFEDC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS/MEMORY MANAGEMENT: add document files for mm
has been removed from the -mm tree.  Its filename was
     maintainers-memory-management-add-document-files-for-mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS/MEMORY MANAGEMENT: add document files for mm
Date: Fri, 1 Nov 2024 13:23:10 -0700

Memory managment subsystem documents ('admin-guide/mm/' and 'mm/' under
'Documentation/') are not marked as managed under memory management
subsystem.  This makes 'get_maintainer.pl' for changes to the documents
sub-optimal.  Mark the documents as part of mm subsystem on MAINTAINERS
file.

Link: https://lkml.kernel.org/r/20241101202311.53935-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-memory-management-add-document-files-for-mm
+++ a/MAINTAINERS
@@ -14848,6 +14848,8 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
+F:	Documentation/admin-guide/mm/
+F:	Documentation/mm/
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/memfd.h
_

Patches currently in -mm which might be from sj@kernel.org are


