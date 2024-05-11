Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64346A921;
	Sat, 11 May 2024 22:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467333; cv=none; b=nseeO+AbZie04qm+Fu6SBmNT6wbJRuy49s5vnKsl/TNNij5mthrwlNu0Zc3qzCEq4EqfYnCc2p9iap20W5fpmXz2YhBdsB7qIui0+8JdWaLx66stBE6489xs1rhTL9rx2xe1tHEPQlgNVaQNRv6IU11Y9K4ECpXxQvgAIS3yClQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467333; c=relaxed/simple;
	bh=51wgTNHC2oE+4wLjFJTbhN9WW+lWN+Wl5SnoS4DnUjA=;
	h=Date:To:From:Subject:Message-Id; b=uGOuBFnl3g0fn+Y89sl+BSWv9bR91pA4mmsUCQjgdx/QqzDE2Z/k0teZjoAmFojpxI2saTPn1KNbCwl/Rj+uUMwXWyEcXmduvzuGRE/F6FgihcY6ZaBS4ADqWQLosFtMl1D/eaYQsYiI5Q9xNFm+Py9P8kIckCFnZofbJRuZ8nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b3MCZSEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b3MCZSEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390B2C4AF08;
	Sat, 11 May 2024 22:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467333;
	bh=51wgTNHC2oE+4wLjFJTbhN9WW+lWN+Wl5SnoS4DnUjA=;
	h=Date:To:From:Subject:From;
	b=b3MCZSEkUX8jqaHVXZFYwh0hN3zDETzSBk8VIdMiUlI5K3TC3Tv/DO2o7FffOB++L
	 ALjiweysGfFPhmDQ56FBaLPw/NfZjoRI856PuQypijE4EpeB+w8Kty4QUH3rUKPRf5
	 Dr5nUEiIkkkM8ZcdIQB2kQgZW3F77Dlh1HvaLvXc=
Date: Sat, 11 May 2024 15:42:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch removed from -mm tree
Message-Id: <20240511224213.390B2C4AF08@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
Date: Fri, 3 May 2024 11:03:15 -0700

To update effective size quota of DAMOS schemes on DAMON sysfs file
interface, user should write 'update_schemes_effective_quotas' to the
kdamond 'state' file.  But the document is mistakenly saying the input
string as 'update_schemes_effective_bytes'.  Fix it (s/bytes/quotas/).

Link: https://lkml.kernel.org/r/20240503180318.72798-8-sj@kernel.org
Fixes: a6068d6dfa2f ("Docs/admin-guide/mm/damon/usage: document effective_bytes file")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.9.x]
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -153,7 +153,7 @@ Users can write below commands for the k
 - ``clear_schemes_tried_regions``: Clear the DAMON-based operating scheme
   action tried regions directory for each DAMON-based operation scheme of the
   kdamond.
-- ``update_schemes_effective_bytes``: Update the contents of
+- ``update_schemes_effective_quotas``: Update the contents of
   ``effective_bytes`` files for each DAMON-based operation scheme of the
   kdamond.  For more details, refer to :ref:`quotas directory <sysfs_quotas>`.
 
@@ -342,7 +342,7 @@ Based on the user-specified :ref:`goal <
 effective size quota is further adjusted.  Reading ``effective_bytes`` returns
 the current effective size quota.  The file is not updated in real time, so
 users should ask DAMON sysfs interface to update the content of the file for
-the stats by writing a special keyword, ``update_schemes_effective_bytes`` to
+the stats by writing a special keyword, ``update_schemes_effective_quotas`` to
 the relevant ``kdamonds/<N>/state`` file.
 
 Under ``weights`` directory, three files (``sz_permil``,
_

Patches currently in -mm which might be from sj@kernel.org are


