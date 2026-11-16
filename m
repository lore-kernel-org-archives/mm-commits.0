Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847345;
	b=W5sf3Gyc2g9YjigPHjjoSAH/F5Zyd6Do97QEwV8PEwrZwRGT5GCFgDmLvVNR7Wq3aiYL
	 oqRD3YJv5a/2Rv9xTxkicExCPhnZq/tpjQ0hvcn5gUKHxXdNiK2uPCkws9rPHTU5fI5XV
	 BjbDohgV69WfVcvkFg9zuUmT3d7vw9kg8JsOVB+5JKxkwjdVn5vf7bgFuwZRm5nNtN5to
	 uP8C1c6X7JZJWQGYCFJ2gAiYprNpsB9CTGgZwXYGrvJ8Y+QpgJ0ypYHeH5Zg+97KfU/KL
	 gUSBLA4xSNDoqrA7uhuDh6NCBGhCM4HTPZ+d7hwS3/IMezfhcpEcRqN43LePVUqzphg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847345;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0o1NHZf9B234tljzZY/iCDQb/cCxj2fMY+QKgiVA8AQ=;
	b=36/2oG0PxUOMAibuZOMSXG5C+mziBXMDwLpY3dZ02EFVsNW7ZWMqNo6W0wSN4OsLAo5Y
	 3a/d9NMwx54aH/atNNk6e1ueTe8UcerV6PHTmVvjKN3BSWXwBWQOY3da7zGLGNwzjDgxx
	 3DXewV+z0S6D5yEz23hSjDxaTuzaZGss1J0fK1rhh+5hkCWagsaConqh7WU60mtiiIMAH
	 YAw+rhXCbD+9yNlr+3RmHShIP9kCRhdI3pkxU7zZNp7GQn71ltxqOGGeKLsO2MWN2grly
	 +8IF8YE8yJ7ajbPmF3B64wwdov5+6brDMzYE/VHONrQeYusZ95xwPRS5XlqfWYuR6UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VIJg0rNj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43490606A31C
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 16:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VIJg0rNj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8ED1F000C4;
	Mon, 16 Nov 2026 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794847344;
	bh=0o1NHZf9B234tljzZY/iCDQb/cCxj2fMY+QKgiVA8AQ=;
	h=Date:To:From:Subject;
	b=VIJg0rNjuNyXRE0Vb+AG16l/ydgiSd2Um2/Q3XKIOPs1UNFe+g7boRRXn8qSz0V6o
	 zMf9zcNI3l84lQB+1eZvp7aQnI3vYWGk+IGpYPn+9c8d6LQ11tFnq9llocrbNzCEEY
	 Mtj2RagwWg9G/L41t4d+hJrKoSyMD5kiuPU7N1Y0=
Date: Mon, 16 Nov 2026 08:42:24 -0800
To: mm-commits@vger.kernel.org,yang_yongxin123@163.com,broonie@kernel.org,
	brauner@kernel.org,brads@mainlining.org,akpm@linux-foundation.org,
	yangyongxin@kylinos.cn
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] perf-profile-report-failure-to-create-proc-profile.patch removed from -mm tree
Message-Id: <20261116164224.AA8ED1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: perf/profile: report failure to create /proc/profile
has been removed from the -mm tree.  Its filename was
     perf-profile-report-failure-to-create-proc-profile.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Yongxin Yang <yangyongxin@kylinos.cn>
Subject: perf/profile: report failure to create /proc/profile
Date: Wed,  4 Nov 2026 17:32:58 +0800

create_proc_profile() discards the result of proc_create(): when the entry
cannot be created, the function still returns 0 and profiling setup
silently pretends to have succeeded.  The local variable err is never
assigned anything but 0 and only hides that.

Report the failure and return -ENOMEM instead.

create_proc_profile() is a subsys_initcall and do_initcall_level()
discards the initcall return value, so the error message is what the user
will actually see.

Link: https://lore.kernel.org/20261104093258.1802802-1-yangyongxin@kylinos.cn
Signed-off-by: Yongxin Yang <yangyongxin@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: <yang_yongxin123@163.com>

 kernel/profile.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/profile.c~perf-profile-report-failure-to-create-proc-profile
+++ a/kernel/profile.c
@@ -240,15 +240,17 @@ static const struct proc_ops profile_pro
 int __ref create_proc_profile(void)
 {
 	struct proc_dir_entry *entry;
-	int err = 0;
 
 	if (!prof_on)
 		return 0;
 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
 			    NULL, &profile_proc_ops);
-	if (entry)
-		proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
-	return err;
+	if (!entry) {
+		pr_err("profile: failed to create /proc/profile\n");
+		return -ENOMEM;
+	}
+	proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
+	return 0;
 }
 subsys_initcall(create_proc_profile);
 #endif /* CONFIG_PROC_FS */
_

Patches currently in -mm which might be from yangyongxin@kylinos.cn are


