Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE5E372EDD
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028839; cv=none; b=Sa2QpfB9iIHihbcwv59ZVKcWRRRRQQXnMPuAQKhPqF2nThdHO3OQIcU0vZAL6dx2+99WdMXmfH1eXJHbfpjtkuye2kaihlSgROblNyZ1050a3bJXPKvO8hQwqP3NAISQgDGDk4H/a1WNb9H2mch9Lm7o8sBVVBVrtSOa0SebUVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028839; c=relaxed/simple;
	bh=ZRUa7OfrN/KIjhkDNM6cwJfygtqoqWMxjZ5B/J/nlNc=;
	h=Date:To:From:Subject:Message-Id; b=sBE3Pgq7LZjXGH6C1WlsgIUJlW+1g6LMjJ+IV0JfJd7sHvZOvYXSJ4oWcSLhSDXqNZuzG8XDtii3ijjnS1Daynps2bEfnhWkxqHaHfgVDpSSdxRS59cYw/uZK16okGN1dTOuMFxEvXxewaT5H1oPkOlJeo5gKri4YonA0mX/hkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKzDhIaP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKzDhIaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2511F00898;
	Fri, 29 May 2026 04:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028837;
	bh=BEe55qvjkeChxfe3po9R3h4V7BsG1cx4Zt7ApVcGJ2M=;
	h=Date:To:From:Subject;
	b=EKzDhIaPKZFKTrZ3LmUUV45FJXktRJvU1zHTH+1G4p/1wFDIy3+UmfSgU0298mBfK
	 Fu3+bx0kBfT8CmPPqB49TYH/h9E5gJ4bqkECnSAlLOAz4j33mNLZ8xv7QJfVju5a2E
	 ZxnzWNtwcRFUb3UL/bmpq/2ZHZCairRmnKQ/710A=
Date: Thu, 28 May 2026 21:27:17 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,david@davidgow.net,brendan.higgins@linux.dev,andriy.shevchenko@linux.intel.com,sozdayvek@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-uuid_kunit-add-tests-for-the-four-random-uuid-guid-generators.patch removed from -mm tree
Message-Id: <20260529042717.CE2511F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/uuid_kunit: add tests for the four random UUID/GUID generators
has been removed from the -mm tree.  Its filename was
     lib-uuid_kunit-add-tests-for-the-four-random-uuid-guid-generators.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stepan Ionichev <sozdayvek@gmail.com>
Subject: lib/uuid_kunit: add tests for the four random UUID/GUID generators
Date: Sat, 16 May 2026 17:09:15 +0500

uuid_kunit currently exercises only guid_parse() and uuid_parse() (plus
their invalid-input paths).  The four random generators exported from
lib/uuid.c -- generate_random_uuid(), generate_random_guid(), uuid_gen()
and guid_gen() -- have no direct kunit coverage.

Random output cannot be compared against a fixed expected value, but RFC
4122 section 4.4 specifies two invariants that any version-4 random
UUID/GUID must satisfy:

  - version 4 in the high nibble of the version byte
    (byte 6 in the wire uuid_t layout, byte 7 in the byte-swapped
    guid_t layout);
  - variant DCE 1.1 (binary 10x) in the high bits of byte 8.

Add four test cases that invoke each generator several times and verify
these bit patterns hold.  The same checks catch a regression in either the
mask/OR sequence in the generators or the layout constants.  Run the loop
a handful of times to cover the small but non-zero chance that an unmasked
random byte happens to satisfy the version/variant pattern by accident on
a single call.

Link: https://lore.kernel.org/20260516120915.40544-1-sozdayvek@gmail.com
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/uuid_kunit.c |   56 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/lib/tests/uuid_kunit.c~lib-uuid_kunit-add-tests-for-the-four-random-uuid-guid-generators
+++ a/lib/tests/uuid_kunit.c
@@ -86,11 +86,67 @@ static void uuid_test_uuid_invalid(struc
 	}
 }
 
+/*
+ * RFC 4122 section 4.4 says random UUIDs/GUIDs (version 4) must have:
+ *   - version 4 in the high nibble of the version byte,
+ *   - variant DCE 1.1 (binary 10x) in the high bits of byte 8.
+ *
+ * The version byte is byte 6 in the "wire" uuid_t layout and byte 7 in
+ * the byte-swapped guid_t layout.
+ */
+static void uuid_test_uuid_gen(struct kunit *test)
+{
+	uuid_t u;
+
+	for (unsigned int i = 0; i < 8; i++) {
+		uuid_gen(&u);
+		KUNIT_EXPECT_EQ(test, u.b[6] & 0xf0, 0x40);
+		KUNIT_EXPECT_EQ(test, u.b[8] & 0xc0, 0x80);
+	}
+}
+
+static void uuid_test_guid_gen(struct kunit *test)
+{
+	guid_t g;
+
+	for (unsigned int i = 0; i < 8; i++) {
+		guid_gen(&g);
+		KUNIT_EXPECT_EQ(test, g.b[7] & 0xf0, 0x40);
+		KUNIT_EXPECT_EQ(test, g.b[8] & 0xc0, 0x80);
+	}
+}
+
+static void uuid_test_generate_random_uuid(struct kunit *test)
+{
+	unsigned char buf[16];
+
+	for (unsigned int i = 0; i < 8; i++) {
+		generate_random_uuid(buf);
+		KUNIT_EXPECT_EQ(test, buf[6] & 0xf0, 0x40);
+		KUNIT_EXPECT_EQ(test, buf[8] & 0xc0, 0x80);
+	}
+}
+
+static void uuid_test_generate_random_guid(struct kunit *test)
+{
+	unsigned char buf[16];
+
+	for (unsigned int i = 0; i < 8; i++) {
+		generate_random_guid(buf);
+		KUNIT_EXPECT_EQ(test, buf[7] & 0xf0, 0x40);
+		KUNIT_EXPECT_EQ(test, buf[8] & 0xc0, 0x80);
+	}
+}
+
 static struct kunit_case uuid_test_cases[] = {
 	KUNIT_CASE(uuid_test_guid_valid),
 	KUNIT_CASE(uuid_test_uuid_valid),
 	KUNIT_CASE(uuid_test_guid_invalid),
 	KUNIT_CASE(uuid_test_uuid_invalid),
+	KUNIT_CASE(uuid_test_uuid_gen),
+	KUNIT_CASE(uuid_test_guid_gen),
+	KUNIT_CASE(uuid_test_generate_random_uuid),
+	KUNIT_CASE(uuid_test_generate_random_guid),
 	{},
 };
 
_

Patches currently in -mm which might be from sozdayvek@gmail.com are


