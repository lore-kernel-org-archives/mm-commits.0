From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 116/118] execve: warn if process starts with
 executable stack
Date: Thu, 30 Jan 2020 22:17:29 -0800
Message-ID: <20200131061729.W90ZrwXqp%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:30 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, dan.carpenter@oracle.com, ebiederm@xmission.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, will@kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: execve: warn if process starts with executable stack

There were few episodes of silent downgrade to an executable stack over
years:

1) linking innocent looking assembly file will silently add executable
   stack if proper linker options is not given as well:

	$ cat f.S
	.intel_syntax noprefix
	.text
	.globl f
	f:
	        ret

	$ cat main.c
	void f(void);
	int main(void)
	{
	        f();
	        return 0;
	}

	$ gcc main.c f.S
	$ readelf -l ./a.out
	  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                         0x0000000000000000 0x0000000000000000  RWE    0x10
			 					 ^^^

2) converting C99 nested function into a closure
https://nullprogram.com/blog/2019/11/15/

	void intsort2(int *base, size_t nmemb, _Bool invert)
	{
	    int cmp(const void *a, const void *b)
	    {
	        int r = *(int *)a - *(int *)b;
	        return invert ? -r : r;
	    }
	    qsort(base, nmemb, sizeof(*base), cmp);
	}

will silently require stack trampolines while non-closure version will not.

Without doubt this behaviour is documented somewhere, add a warning so
that developers and users can at least notice.  After so many years of
x86_64 having proper executable stack support it should not cause too many
problems.

Link: http://lkml.kernel.org/r/20191208171918.GC19716@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Will Deacon <will@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/exec.c~execve-warn-if-process-starts-with-executable-stack
+++ a/fs/exec.c
@@ -761,6 +761,11 @@ int setup_arg_pages(struct linux_binprm
 		goto out_unlock;
 	BUG_ON(prev != vma);
 
+	if (unlikely(vm_flags & VM_EXEC)) {
+		pr_warn_once("process '%pD4' started with executable stack\n",
+			     bprm->file);
+	}
+
 	/* Move stack pages down in memory. */
 	if (stack_shift) {
 		ret = shift_arg_pages(vma, stack_shift);
_
