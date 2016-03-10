From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-hugetlb_no_page-rate-limit-warning-message.patch removed from
 -mm tree
Date: Thu, 10 Mar 2016 10:57:52 -0800
Message-ID: <56e1c3b0.zeE/U58XRmpQmdiH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbcCJS5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geofft@ldpreload.com, dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: hugetlb_no_page: rate-limit warning message
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-hugetlb_no_page-rate-limit-warning-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geoffrey Thomas <geofft@ldpreload.com>
Subject: mm/hugetlb: hugetlb_no_page: rate-limit warning message

The warning message "killed due to inadequate hugepage pool" simply
indicates that SIGBUS was sent, not that the process was forcibly killed. 
If the process has a signal handler installed does not fix the problem,
this message can rapidly spam the kernel log.

On my amd64 dev machine that does not have hugepages configured, I can
reproduce the repeated warnings easily by setting vm.nr_hugepages=2 (i.e.,
4 megabytes of huge pages) and running something that sets a signal
handler and forks, like

#include <sys/mman.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

sig_atomic_t counter = 10;
void handler(int signal) {
 	if (counter-- == 0)
 		exit(0);
}

int main(void) {
 	int status;
 	char *addr = mmap(NULL, 4 * 1048576, PROT_READ | PROT_WRITE,
 			  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	if (addr == MAP_FAILED) {perror("mmap"); return 1;}
 	*addr = 'x';
 	switch (fork()) {
 		case -1:
 			perror("fork"); return 1;
 		case 0:
 			signal(SIGBUS, handler);
 			*addr = 'x';
 			break;
 		default:
 			*addr = 'x';
 			wait(&status);
 			if (WIFSIGNALED(status)) {
 				psignal(WTERMSIG(status), "child");
 			}
 			break;
 	}
}

Signed-off-by: Geoffrey Thomas <geofft@ldpreload.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-hugetlb_no_page-rate-limit-warning-message mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-hugetlb_no_page-rate-limit-warning-message
+++ a/mm/hugetlb.c
@@ -3502,7 +3502,7 @@ static int hugetlb_no_page(struct mm_str
 	 * COW. Warn that such a situation has occurred as it may not be obvious
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
-		pr_warning("PID %d killed due to inadequate hugepage pool\n",
+		pr_warn_ratelimited("PID %d killed due to inadequate hugepage pool\n",
 			   current->pid);
 		return ret;
 	}
_

Patches currently in -mm which might be from geofft@ldpreload.com are


