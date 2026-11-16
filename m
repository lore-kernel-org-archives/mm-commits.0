Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794848169;
	b=FqZ/Uf1dWeLGcDCz50xw1YJ6/ZQ9VyDF7zFiIQIrtRMY3cEkRDr6WDD1C8Oq85l0C8l1
	 jpvAPmuzn1cH4P7RR2hXlJvht+HiJpls/wbVWEhHdcQ+XLebkaQuxWr3uj6ZFa6Pfbg4f
	 Ix+ODJwUCds31BRH6fQLVNXbYS07SvZQlcXue2N0QlDk63jk+XPdy4bS8P8cLHHLp35O7
	 RtoeVSUtpdtcNCbu7nKjJeaUulD5z6V89tYVnG0BVK0vwlAOx6FlOxBujA8QPMZj/8fkh
	 fA4K8CNpvc3HtFG+2krO+gQ4TlvwaJbOtVxJ3PY0hCApXn+hf7t5DC7Cxymz9igbXNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848169;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Subject:In-Reply-To:
	 References:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=G4IV0HRnzVK20g1ZeEbXBlgz5tfW+NIW5VQHMIKFWaY=;
	b=tdo5wIVb8hH0hH5YB7d1QzsAo71Aw72XdPuI2lMUWrebg6qRfLVOMvgS2f1KYvi9/oMv
	 5I5n0e47Kdl0KO8SLnSk+QN/voBkk/27SqGK6Nul9hhbREHeI97LSkfMYmWlWttL3Ppk9
	 tS91AC/Le+vm1MYIwShFqhoS2Cwrkmhd2I2wrItUvB67+o10vM9503Hr90Xph2KnnX0K+
	 yJri5SSy4CVWwpE5dndwE48abooOFibXFGtjIsIkmVkhq3lComSYMnwz99gAsEf+FYY/V
	 ebPGKyYALlnuJIJaysFhcdkf1GLwuPy4lBLPXrKGrgSEKwKXsPqa3dPuB9XhqVwM+FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xxXKid4x;
	arc=none smtp.remote-ip=91.218.175.118
Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522D7606A334
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 16:56:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 522D7606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xxXKid4x
X-Envelope-To: mm-commits@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hzs6kN4yr8ApoWfqQgbtNpTLYT3KWFlZ1IEcNgHAb38=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794848164; v=1; x=1795452964;
 b=xxXKid4x3KdgQDJX3H1hX7unoi8Y/s6cqN7W1VWY8WQluGPJ2FcctqX30DJxH3aHOfk8Eu7D
 KTCc/G68lse9fKpdGpX4Q1XXxRamPcu8MjfuLbr5D8gsVaMRdXKb/9RFES2X41WwXh6U2e0pDfe
 pKOqND9iEWQUPjTJ8YjEhBIE=
X-Envelope-To: mm-commits@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a734947b68407823;
	Mon, 16 Nov 2026 16:56:04 +0000
X-Mizu-Trace-ID: a734947b68407823
X-Migadu-Flow: FLOW_OUT
Date: Mon, 16 Nov 2026 16:55:58 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 yang_yongxin123@163.com, broonie@kernel.org, brauner@kernel.org,
 akpm@linux-foundation.org, yangyongxin@kylinos.cn
Subject: =?US-ASCII?Q?Re=3A_=5Bobsolete=5D_perf-profile-report-failure-to-?=
 =?US-ASCII?Q?create-proc-profile=2Epatch_removed_from_-mm_tree?=
In-Reply-To: <20261116164224.AA8ED1F000C4@smtp.kernel.org>
References: <20261116164224.AA8ED1F000C4@smtp.kernel.org>
Message-ID: <F0C47A12-7949-456F-8E54-F248C585FC60@linux.dev>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 16 November 2026 16:42:24 GMT, Andrew Morton <akpm@linux-foundation.org>
wrote:
>
>The quilt patch titled
>     Subject: perf/profile: report failure to create /proc/profile
>has been removed from the -mm tree.  Its filename was
>     perf-profile-report-failure-to-create-proc-profile.patch
>
>This patch was dropped because it is obsolete

Huh?

>
>------------------------------------------------------
>From: Yongxin Yang <yangyongxin@kylinos.cn>
>Subject: perf/profile: report failure to create /proc/profile
>Date: Wed,  4 Nov 2026 17:32:58 +0800
>
>create_proc_profile() discards the result of proc_create(): when the entry
>cannot be created, the function still returns 0 and profiling setup
>silently pretends to have succeeded.  The local variable err is never
>assigned anything but 0 and only hides that.
>
>Report the failure and return -ENOMEM instead.
>
>create_proc_profile() is a subsys_initcall and do_initcall_level()
>discards the initcall return value, so the error message is what the user
>will actually see.
>
>Link: https://lore.kernel.org/20261104093258.1802802-1-yangyongxin@kylinos.cn
>Signed-off-by: Yongxin Yang <yangyongxin@kylinos.cn>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
>Reviewed-by: Bradley Morgan <brads@mainlining.org>
>Cc: Christian Brauner <brauner@kernel.org>
>Cc: Mark Brown <broonie@kernel.org>
>Cc: <yang_yongxin123@163.com>
>
> kernel/profile.c |   10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-)
>
>--- a/kernel/profile.c~perf-profile-report-failure-to-create-proc-profile
>+++ a/kernel/profile.c
>@@ -240,15 +240,17 @@ static const struct proc_ops profile_pro
> int __ref create_proc_profile(void)
> {
> 	struct proc_dir_entry *entry;
>-	int err = 0;
> 
> 	if (!prof_on)
> 		return 0;
> 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
> 			    NULL, &profile_proc_ops);
>-	if (entry)
>-		proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
>-	return err;
>+	if (!entry) {
>+		pr_err("profile: failed to create /proc/profile\n");
>+		return -ENOMEM;
>+	}
>+	proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
>+	return 0;
> }
> subsys_initcall(create_proc_profile);
> #endif /* CONFIG_PROC_FS */
>_
>
>Patches currently in -mm which might be from yangyongxin@kylinos.cn are
>
>

--- Thanks!
