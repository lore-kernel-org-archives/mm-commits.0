Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795639699;
	b=zSXyD+7dP6//8Mz3yvbfDOGX+SQkcGAhHpMgW25hWCtPMfTXgwyMLkBhxh+FXMJYGPz1
	 eoC4JC65LnRKnOz/+4JRs71N8eQBDpI06jVZN0JfXdzDnMDBT0RduwNOF4SI2HBHKunxj
	 cojdI/kr4/XvmpGw/XDNmG+ju3L/ptHcrPq8RtuHG5yYZqSjY4st0/FHwh08bBQjMGV7h
	 7BGPA4ivIV1UJyCnLqOkGVhsssN38jmVX+8WFL/3fFp578k+BZfl/FcjIQ8vCNWERyb2z
	 ikqqMRB/goaiXcg3oWs2uXlLRLX9GYG5vrDs7nLT4m3DxI3G22CsJuYhTcAfU1w/Z3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795639699;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=zDfIFTuxY9sMxl8pG0cnplIOmfvZtrsWweEREbvVxVM=;
	b=TBIiw96AtHSCNiOVcg27z78FRVZ1cNH8D1KHjYvuf+dFkZkxXkPF7vMmfq/xmcMiNU4S
	 LNuCJUgjssnhYT8ISY7DgYFG7tX/PFp1yArxgUyTuoxMEo0unonAgfEGbUq1nlzNDfLVC
	 dUvNZKnsTDN8hoOZr2sSFtK65qD3aHnIjRZ9i8N3yLS0cemKysimw5HrIJfaOHH5OFM+h
	 8FPzEx3p029kY2ydK0FbiDN/PAHAKcjpr+Yyc4/k0h8Nu1VVeAVqmty18NCvXLgnCRgqs
	 w5ZjEL1J7yvAiAlBCVHtniV4WHdmbeNKa134G4oNQBq/zAaTUxdxfDR0/YGgLygB4oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1CCakkzK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C961606A321;
	Wed, 25 Nov 2026 20:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1CCakkzK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2885E1F000C6;
	Wed, 25 Nov 2026 20:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795639698;
	bh=zDfIFTuxY9sMxl8pG0cnplIOmfvZtrsWweEREbvVxVM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=1CCakkzKq97aSuIxLd0QJyJUk2/QvIFntVR9EOpiX82n8QSYrKCwE/LoR/QoYAYVs
	 gBbwIX4q4l1ItH7+t+sQh3KkLxquh6akEVCoUlMOGuSI5jyySCQZRaNoKTfMGHXRhd
	 MFIF7raNdPA4TsPfjPhC7k3sPi9gEqy+DTsCvaQs=
Date: Wed, 25 Nov 2026 12:48:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,
	nphamcs@gmail.com,jack@suse.cz,hannes@cmpxchg.org,bsdhenrymartin@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125030432.274396-1-bsdhenrymartin@gmail.com>
References: <20261125030432.274396-1-bsdhenrymartin@gmail.com>
Subject: + mm-report-all-zero-cachestat-for-dax-mappings.patch added to mm-hotfixes-unstable branch
Message-Id: <20261125204818.2885E1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: report all-zero cachestat for DAX mappings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-report-all-zero-cachestat-for-dax-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-report-all-zero-cachestat-for-dax-mappings.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Henry Martin <bsdhenrymartin@gmail.com>
Subject: mm: report all-zero cachestat for DAX mappings
Date: Wed, 25 Nov 2026 11:04:32 +0800

filemap_cachestat() treats every xarray value entry as a workingset
shadow.  On DAX mappings, value entries are DAX exceptional entries: same
value bit, different bit layout (flags in the low bits, pfn above). 
Decoded as a shadow, a DAX entry yields a bogus node id; NODE_DATA() for
it can be NULL, and lru_gen_test_recent() then dereferences it:

  Oops: general protection fault
  RIP: 0010:lru_gen_test_recent+0xde/0x300
  Call Trace:
   workingset_test_recent
   filemap_cachestat
   __x64_sys_cachestat

Any writable file on a DAX mount triggers this once an mmap write fault
has populated entries.

DAX mappings have no page cache, so none of the cachestat fields make
sense for them.  Skip the xarray walk for them and report all zeros, and
document the behaviour in the syscall's kernel-doc.

This issue was discovered by Tencent CodeBuddy Security.

Link: https://patch.msgid.link/20261125030432.274396-1-bsdhenrymartin@gmail.com
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>

 mm/filemap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-report-all-zero-cachestat-for-dax-mappings
+++ a/mm/filemap.c
@@ -4789,7 +4789,8 @@ static inline bool can_do_cachestat(stru
  * The `flags` argument is unused for now, but is included for future
  * extensibility. User should pass 0 (i.e no flag specified).
  *
- * Currently, hugetlbfs is not supported.
+ * Currently, hugetlbfs is not supported.  DAX mappings have no page
+ * cache, so cachestat() always reports all zeros for them.
  *
  * Because the status of a page can change after cachestat() checks it
  * but before it returns to the application, the returned values may
@@ -4834,7 +4835,10 @@ SYSCALL_DEFINE4(cachestat, unsigned int,
 		csr.len == 0 ? ULONG_MAX : (csr.off + csr.len - 1) >> PAGE_SHIFT;
 	memset(&cs, 0, sizeof(struct cachestat));
 	mapping = fd_file(f)->f_mapping;
-	filemap_cachestat(mapping, first_index, last_index, &cs);
+
+	/* DAX mappings have no page cache; report all zeros. */
+	if (!dax_mapping(mapping))
+		filemap_cachestat(mapping, first_index, last_index, &cs);
 
 	if (copy_to_user(cstat, &cs, sizeof(struct cachestat)))
 		return -EFAULT;
_

Patches currently in -mm which might be from bsdhenrymartin@gmail.com are

mm-report-all-zero-cachestat-for-dax-mappings.patch

