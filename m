Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7663D1DE4E1;
	Sat, 15 Nov 2025 18:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763232762; cv=none; b=VMZ0HVTb69UFW2QH/X/dOnNtElFsVHthcDMrc4CgfjsRcAgQdNf8daTrnIS+JOqWI+AebQ4hJc2PZXY6zHKcSmgD9vMVqS6t+ExaOocZ26xeWaegBpzhlXdTRRQoPtbZzbh5u/e6FV/gFsgzG7CZZAbJg5gk/7wqzhgz2P5wgzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763232762; c=relaxed/simple;
	bh=NHHjcl0cRdf4vdTas5t886wmOze73D28jlmSjFyY9Tw=;
	h=Date:To:From:Subject:Message-Id; b=kaQKbdVGJSS7O4qtQ35ypPx9JQO+At7EjXqCWiTkD6wKNBfydKBM4w5nO5rsOKEQVIInDeLl9FIheCTxoa4NeapUc+uMUzWNznjA0RAoVbHg/UTrfEgHskajYVkeDnXyuKBrbykmsuH3gFz1X/u/gQz2/0Zkb9AgAqnNZSVNOtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ahe9REFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ahe9REFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAE9C113D0;
	Sat, 15 Nov 2025 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763232762;
	bh=NHHjcl0cRdf4vdTas5t886wmOze73D28jlmSjFyY9Tw=;
	h=Date:To:From:Subject:From;
	b=ahe9REFNANMX161P+QXM+ATmx9+0jnILHWRwICwaia4AqisZV16WGbYSkwfHtmBm7
	 JL4GNvaLl1exXLjF5PsEw2sq+Iz7jvkNZOCxvSGcFSDNpXIpjanhwIoFveEVdAFROm
	 FzkSLI0BfKnuv08YEy8uPER+ZtBOiZGdeGi4Tg8Y=
Date: Sat, 15 Nov 2025 10:52:41 -0800
To: mm-commits@vger.kernel.org,sunliming@kylinos.cn,stable@vger.kernel.org,shuah@kernel.org,rostedt@goodmis.org,richard.weiyang@gmail.com,mhiramat@kernel.org,beaub@linux.microsoft.com,ankitkhushwaha.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test.patch removed from -mm tree
Message-Id: <20251115185242.3AAE9C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/user_events: fix type cast for write_index packed member in perf_test
has been removed from the -mm tree.  Its filename was
     selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: selftests/user_events: fix type cast for write_index packed member in perf_test
Date: Thu, 6 Nov 2025 15:25:32 +0530

Accessing 'reg.write_index' directly triggers a -Waddress-of-packed-member
warning due to potential unaligned pointer access:

perf_test.c:239:38: warning: taking address of packed member 'write_index'
of class or structure 'user_reg' may result in an unaligned pointer value
[-Waddress-of-packed-member]
  239 |         ASSERT_NE(-1, write(self->data_fd, &reg.write_index,
      |                                             ^~~~~~~~~~~~~~~

Since write(2) works with any alignment. Casting '&reg.write_index'
explicitly to 'void *' to suppress this warning.

Link: https://lkml.kernel.org/r/20251106095532.15185-1-ankitkhushwaha.linux@gmail.com
Fixes: 42187bdc3ca4 ("selftests/user_events: Add perf self-test for empty arguments events")
Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: sunliming <sunliming@kylinos.cn>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/user_events/perf_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/user_events/perf_test.c~selftests-user_events-fix-type-cast-for-write_index-packed-member-in-perf_test
+++ a/tools/testing/selftests/user_events/perf_test.c
@@ -236,7 +236,7 @@ TEST_F(user, perf_empty_events) {
 	ASSERT_EQ(1 << reg.enable_bit, self->check);
 
 	/* Ensure write shows up at correct offset */
-	ASSERT_NE(-1, write(self->data_fd, &reg.write_index,
+	ASSERT_NE(-1, write(self->data_fd, (void *)&reg.write_index,
 					sizeof(reg.write_index)));
 	val = (void *)(((char *)perf_page) + perf_page->data_offset);
 	ASSERT_EQ(PERF_RECORD_SAMPLE, *val);
_

Patches currently in -mm which might be from ankitkhushwaha.linux@gmail.com are

selftest-mm-fix-pointer-comparison-in-mremap_test.patch

