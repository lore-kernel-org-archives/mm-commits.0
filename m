Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3695717A932
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342495; cv=none; b=CEkiZ6UOsu652LxSytFAAIUiFfsCqU7bV1HA2DtP8/8eObPIX4S+xeTLgXdQJahVWxLiR5HHllXyvnbKJOiDfmdXg8ybQ7NQ7/U1m36plvBlwteBiHvQejmCIlnzzj4lY7ULwUaq3sZ9iVSUqECf46m88H4f5ViX+VAy5VvoPww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342495; c=relaxed/simple;
	bh=NQaS2qDWHNh0k8wQJ8Cbj78fUUYA+wU25UwmlUz3sFE=;
	h=Date:To:From:Subject:Message-Id; b=gsRfvFxWCA2UEHLI2rXBuvJxQJpzB8D/lVAJeK3ULSVVOSQTMWOnaRWXvWMdJtNJvzJuNR+Uszm/d9AM32AtgjvmYKKRbDAd7qwkBXwVqQ574fwRvsXPKqvUNcbPeb4ksEaxizDkX6MDhuSzmBhIdi5fnHXHmFEWZnIYIfAESRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qmMgZoJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qmMgZoJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024F0C32781;
	Tue, 25 Jun 2024 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719342495;
	bh=NQaS2qDWHNh0k8wQJ8Cbj78fUUYA+wU25UwmlUz3sFE=;
	h=Date:To:From:Subject:From;
	b=qmMgZoJAcSe9fe8WLDv1T/6LqpToVZzMuM4uMnZsPMfyui4QhWc0VtkUVGbo5t8zA
	 r6it6bgpEbAnDFaa1OufePEucdNxem+hIUOC55msj/448HosPRZGZML7IxNGtqxKqz
	 IAbciioSoGqdmI6s9N/NJzSj+GG8DhvS7mhzPB5w=
Date: Tue, 25 Jun 2024 12:08:14 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + _damon_sysfs-implement-commit-for-online-parameters-update.patch added to mm-unstable branch
Message-Id: <20240625190815.024F0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: _damon_sysfs: implement commit() for online parameters update
has been added to the -mm mm-unstable branch.  Its filename is
     _damon_sysfs-implement-commit-for-online-parameters-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/_damon_sysfs-implement-commit-for-online-parameters-update.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: _damon_sysfs: implement commit() for online parameters update
Date: Tue, 25 Jun 2024 11:05:37 -0700

Users can update DAMON parameters while it is running, using 'commit'
DAMON sysfs interface command.  For testing the feature in future tests,
implement a function for doing that on the test-purpose DAMON sysfs
interface wrapper Python module.

Link: https://lkml.kernel.org/r/20240625180538.73134-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   19 ++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~_damon_sysfs-implement-commit-for-online-parameters-update
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -481,6 +481,25 @@ class Kdamond:
                     goal.effective_bytes = int(content)
         return None
 
+    def commit(self):
+        nr_contexts_file = os.path.join(self.sysfs_dir(),
+                'contexts', 'nr_contexts')
+        content, err = read_file(nr_contexts_file)
+        if err is not None:
+            return err
+        if int(content) != len(self.contexts):
+            err = write_file(nr_contexts_file, '%d' % len(self.contexts))
+            if err is not None:
+                return err
+
+        for context in self.contexts:
+            err = context.stage()
+            if err is not None:
+                return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'commit')
+        return err
+
+
     def commit_schemes_quota_goals(self):
         for context in self.contexts:
             for scheme in context.schemes:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch
selftests-damon-access_memory-use-user-defined-region-size.patch
selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch
selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch
selftests-damon-implement-damos-tried-regions-test.patch
selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch
selftests-damon-implement-test-for-min-max_nr_regions.patch
_damon_sysfs-implement-commit-for-online-parameters-update.patch
selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch

