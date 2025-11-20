Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F822EB5A2
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675126; cv=none; b=rUO1/fcLKZfClFWLTOULHC7bpCJeZJ0wq/N9lf+ArtJVejbqxjga3z8DwI7OV6EBwgUDQxrgzvXWgBZbSa0G1TXppsAwqWpL6+VLehGDfhw1+hQ72wAAN4v50OYnINGYlNNL1kmEMD63GZ57SeXjhgH3hlhvl7+DsclykrrKpx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675126; c=relaxed/simple;
	bh=GLccCLk5rxDJfDWtxav83G+EPq/ziZC5OBaF9goAaes=;
	h=Date:To:From:Subject:Message-Id; b=mLHtJqZU5OW5o2F+IPMpmkFv+fA/cTa0xUwqJTb9492yGHXKOyvfV9e2H9lQKG90HqZfj1YHUGJoIKS+/PlQM6wYqtNpoe7eNF13k02E1AX9z8cC6NeqZPMYtxJKms57Q5N/jLv8EiDK8gyvRHesgyBliA1wdryR6SPSaX/CUAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h/FXFvBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h/FXFvBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C50CC113D0;
	Thu, 20 Nov 2025 21:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675126;
	bh=GLccCLk5rxDJfDWtxav83G+EPq/ziZC5OBaF9goAaes=;
	h=Date:To:From:Subject:From;
	b=h/FXFvBOIop8aFbO+VVOUIq7biInkpG1UObw2kJnJfMiGurR1pBaPvlZRQtcusSSO
	 bacz85GxC1cYxu4yqLVmjjLhcHxn49vXPntaEPbVSNpgbs9zkSphB4HfYOt/FzhSIY
	 2iKCYZeh9QVVzgs49quUve53X3iM22hAVP4gKUGE=
Date: Thu, 20 Nov 2025 13:45:25 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch removed from -mm tree
Message-Id: <20251120214526.6C50CC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: fix a typo on mm-untable link
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: fix a typo on mm-untable link
Date: Wed, 12 Nov 2025 07:41:11 -0800

Commit 0b473f9e6eac ("Docs/mm/damon/maintainer-profile: update for mm-new
tree") mistakenly forgot putting a space between a link and the next word.
Fix it.

Link: https://lkml.kernel.org/r/20251112154114.66053-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -57,7 +57,7 @@ Key cycle dates
 
 Patches can be sent anytime.  Key cycle dates of the `mm-new
 <https://git.kernel.org/akpm/mm/h/mm-new>`_, `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_and `mm-stable
+<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and `mm-stable
 <https://git.kernel.org/akpm/mm/h/mm-stable>`_ trees depend on the memory
 management subsystem maintainer.
 
_

Patches currently in -mm which might be from sj@kernel.org are


