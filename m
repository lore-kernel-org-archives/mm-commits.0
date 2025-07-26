Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5402286D56
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567830; cv=none; b=lipfkoANRMZEZc1IjKksRShpVzFsa9+rPC6CrA9lB8iFsY0pWuZe7AN7RnuypouGQS4MC+WM8VSmzZ5rWU3qUGuY6YLnwLYdQNqbw8Uk/KVnHLCSWOe9U0HtYcTqcFPmAO3FNkbX2zbgGs88I635H1Me76/ZuJcswnpdKGo3jmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567830; c=relaxed/simple;
	bh=cxR/jEFqZn7vy1qo6cTmmQMTBokvyPjtW7KulWIMiKg=;
	h=Date:To:From:Subject:Message-Id; b=mWSGIjkeQmbkL6ZlfRVvePWFVV0MnSsUuh5mnWgYvy6nlaDixZ0KTDXyr5aHgi1Dr4Xlw118eJWqqs4WkIBFJtx/axlW7T7wqZevNB96B/0AdN1NxNjGHd5QKK5PQu802DXvzayTOCH5Cyzc7PqqBxvAKnI6pNLnBNPSeOUn3fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cm0F4J2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cm0F4J2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBECC4CEF6;
	Sat, 26 Jul 2025 22:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567830;
	bh=cxR/jEFqZn7vy1qo6cTmmQMTBokvyPjtW7KulWIMiKg=;
	h=Date:To:From:Subject:From;
	b=cm0F4J2jkNRA4O1DWG/bB78NCrg3YiwD+5oE6Ys1OCHrkEvLLAC0pEEucfBDvCDB4
	 Gpw9DSl0i/evJ/LXyNISpfEZrQLQ5LRNg5Q/CV3sk+Npm+j7u0FOZtblp3kHY+alNf
	 7fFjhe1n45Tm3Je5zvtCjH/E5a/wH9IVBU52QInc=
Date: Sat, 26 Jul 2025 15:10:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch removed from -mm tree
Message-Id: <20250726221030.7EBECC4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test runtime reduction of DAMON parameters
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: test runtime reduction of DAMON parameters
Date: Sun, 20 Jul 2025 10:16:52 -0700

sysfs.py is testing if non-default additional parameters can be committed.
Add a test case for further reducing the parameters to the default set.

Link: https://lkml.kernel.org/r/20250720171652.92309-23-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -252,6 +252,20 @@ def main():
 
     assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
 
+    # test online commitment of minimum context.
+    context = _damon_sysfs.DamonCtx()
+    context.idx = 0
+    context.kdamond = kdamonds.kdamonds[0]
+    kdamonds.kdamonds[0].contexts = [context]
+    kdamonds.kdamonds[0].commit()
+
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        exit(1)
+
+    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+
     kdamonds.stop()
 
 if __name__ == '__main__':
_

Patches currently in -mm which might be from sj@kernel.org are


