Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C54302750
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755124106; cv=none; b=FoiIXWothJakGL+7A7WXTapfalrLT1mHEltkFNJ7TtUNbVLIycn+vApJ43JnoFuhLBtGFyl/0psgg0d0N4k1nITiouoWKdUpRh+dA4Xxkk0rRbbh1NbdPTdHY3V+8S/vsaf40CSZgMTsGfY7Xwz+dpUzZ2nKtumOfn8biwXkqkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755124106; c=relaxed/simple;
	bh=AWWcVvNsOjjOtOODHrAzYGFjE3zLAS5mXoEfGV3bfJc=;
	h=Date:To:From:Subject:Message-Id; b=l3EgmgTWVbjfYRQE1U6QKTk8RewJs/L7PlY/XTB5M4Gy8V0JP3rMLfL4rJgMG1pEwvAvlRZm9kJXpeJYykhbMaGhXJ9rFx9QsUA8Ld6mbvg4aqd2M7XoVxJ20KXzKJ9tDDj08DjMq7slLu4ItfA66LzAcVt0Cu6rj6bdIvijVts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U2+6hlEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U2+6hlEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D35C4CEEB;
	Wed, 13 Aug 2025 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755124105;
	bh=AWWcVvNsOjjOtOODHrAzYGFjE3zLAS5mXoEfGV3bfJc=;
	h=Date:To:From:Subject:From;
	b=U2+6hlEtdbB7X1paxEGgBlaVH4tor0uH85XOFxpTuEkRinxIN3zyDrSOfMMS56/pK
	 9CgOJPcJhEkHBsWWYnBlW4khP68OmmPVAU6pURIo/HQ1qK+hxqS+IOFHBWjrmVlng4
	 23mGESbVQ7H8PCfvPvTBX7lCTogICsX3ZKgaZpEg=
Date: Wed, 13 Aug 2025 15:28:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,tmgross@umich.edu,ojeda@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,geliang@kernel.org,gary@garyguo.net,dakr@kernel.org,chentao@kylinos.cn,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-allocator-add-kunit-tests-for-alignment-guarantees.patch added to mm-new branch
Message-Id: <20250813222825.73D35C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: allocator: add KUnit tests for alignment guarantees
has been added to the -mm mm-new branch.  Its filename is
     rust-allocator-add-kunit-tests-for-alignment-guarantees.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-allocator-add-kunit-tests-for-alignment-guarantees.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: rust: allocator: add KUnit tests for alignment guarantees
Date: Thu, 31 Jul 2025 10:50:05 +0800

Add a test module to verify memory alignment guarantees for Rust kernel
allocators.  The tests cover `Kmalloc`, `Vmalloc` and `KVmalloc`
allocators with both standard and large page-aligned allocations.

Key features of the tests:
1. Creates alignment-constrained types:
   - 128-byte aligned `Blob`
   - 8192-byte (4-page) aligned `LargeAlignBlob`
2. Validates allocators using `TestAlign` helper which:
   - Checks address alignment masks
   - Supports uninitialized allocations
3. Tests all three allocators with both alignment requirements:
   - Kmalloc with 128B and 8192B
   - Vmalloc with 128B and 8192B
   - KVmalloc with 128B and 8192B

Link: https://lkml.kernel.org/r/d2e3d6454c1435713be0fe3c0dc444d2c60bba51.1753929369.git.zhuhui@kylinos.cn
Co-developed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/alloc/allocator.rs |   56 +++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/rust/kernel/alloc/allocator.rs~rust-allocator-add-kunit-tests-for-alignment-guarantees
+++ a/rust/kernel/alloc/allocator.rs
@@ -184,3 +184,59 @@ unsafe impl Allocator for KVmalloc {
         unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags, nid) }
     }
 }
+
+#[macros::kunit_tests(rust_allocator)]
+mod tests {
+    use super::*;
+    use core::mem::MaybeUninit;
+    use kernel::prelude::*;
+
+    #[test]
+    fn test_alignment() -> Result {
+        const TEST_SIZE: usize = 1024;
+        const TEST_LARGE_ALIGN_SIZE: usize = kernel::page::PAGE_SIZE * 4;
+
+        // These two structs are used to test allocating aligned memory.
+        // they don't need to be accessed, so they're marked as dead_code.
+        #[expect(dead_code)]
+        #[repr(align(128))]
+        struct Blob([u8; TEST_SIZE]);
+        #[expect(dead_code)]
+        #[repr(align(8192))]
+        struct LargeAlignBlob([u8; TEST_LARGE_ALIGN_SIZE]);
+
+        struct TestAlign<T, A: Allocator>(Box<MaybeUninit<T>, A>);
+        impl<T, A: Allocator> TestAlign<T, A> {
+            fn new() -> Result<Self> {
+                Ok(Self(Box::<_, A>::new_uninit(GFP_KERNEL)?))
+            }
+
+            fn is_aligned_to(&self, align: usize) -> bool {
+                assert!(align.is_power_of_two());
+
+                let addr = self.0.as_ptr() as usize;
+                addr & (align - 1) == 0
+            }
+        }
+
+        let ta = TestAlign::<Blob, Kmalloc>::new()?;
+        assert!(ta.is_aligned_to(128));
+
+        let ta = TestAlign::<LargeAlignBlob, Kmalloc>::new()?;
+        assert!(ta.is_aligned_to(8192));
+
+        let ta = TestAlign::<Blob, Vmalloc>::new()?;
+        assert!(ta.is_aligned_to(128));
+
+        let ta = TestAlign::<LargeAlignBlob, Vmalloc>::new()?;
+        assert!(ta.is_aligned_to(8192));
+
+        let ta = TestAlign::<Blob, KVmalloc>::new()?;
+        assert!(ta.is_aligned_to(128));
+
+        let ta = TestAlign::<LargeAlignBlob, KVmalloc>::new()?;
+        assert!(ta.is_aligned_to(8192));
+
+        Ok(())
+    }
+}
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

rust-allocator-add-kunit-tests-for-alignment-guarantees.patch

