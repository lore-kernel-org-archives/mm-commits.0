Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4D52556E
	for <mm-commits@vger.kernel.org>; Sun, 26 Apr 2026 20:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777233637; cv=none; b=a4lZCHJyyEe6iF/poo8TqjQhmX4mn13bQJHUgxLr9J0uHE7JhshxURFV+zA4X1F69fqILzl1Ivou+I8F3RURcJeSi2Q58HKKao1HMhlw+nYX6RHbebCBzBCR0TLwvaU1CXjLZs52gV8tQHZWdUYtIU6v2tx26r5vWbfinlaHHC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777233637; c=relaxed/simple;
	bh=K13FJ9zqW9MPBWhOiVACNwCMiaTD0sdFz+mKf3Tpc48=;
	h=Date:To:From:Subject:Message-Id; b=I3niMWMFbIzUdY0Oy1ww5cUW9aH1c9rOp53KVbBz9PqDVFWhvWedsxibU9IxCfMSWd441MCkuzEMRCNROGUR7j16q8nRgkrwt/H5+ri+2Asp7Y9DE8VPmcUtaWHVAwoAsNqMLAN3Q1LCLOdti7U0qnjGAj8LOlQufeXxr3ONBGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hPhaeFQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hPhaeFQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E12C2BCAF;
	Sun, 26 Apr 2026 20:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777233636;
	bh=K13FJ9zqW9MPBWhOiVACNwCMiaTD0sdFz+mKf3Tpc48=;
	h=Date:To:From:Subject:From;
	b=hPhaeFQFC5dSwvNUkUcw/jQYc5o9we6Gdc8mA4UU5b6137UAo1d3a8RKWve/Irbq5
	 bLInghRg9QL/UXF2XQ85AfjDUIB4zah/rEQRLos0CVqWntjyQe+g2Ay/xqdQ9f7iRL
	 8Y5MaCuhOQyR4WLJnVnt6xEXxSMgcAgc7/2W/vUc=
Date: Sun, 26 Apr 2026 13:00:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,richard.weiyang@gmail.com,pfalcato@suse.de,paulmck@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-ensure-the-test-is-performed-at-the-right-page-boundary.patch added to mm-new branch
Message-Id: <20260426200036.A1E12C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: ensure the test is performed at the right page boundary
has been added to the -mm mm-new branch.  Its filename is
     selftests-proc-ensure-the-test-is-performed-at-the-right-page-boundary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-ensure-the-test-is-performed-at-the-right-page-boundary.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/proc: ensure the test is performed at the right page boundary
Date: Sat, 25 Apr 2026 23:27:17 -0700

When running tearing tests we need to ensure the pages we use include VMAs
that were mapped by the child process for this test.  Currently we always
use the first two pages, checking VMAs at their boundaries and this works,
however once we add tests for /proc/pid/smaps, the first two pages might
not contain the VMAs that child modifies.  Locate the page that contains
the first VMA mapped by the child and use that and the next page for the
test.

Link: https://lore.kernel.org/20260426062718.1238437-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |  119 +++++++++++++---
 1 file changed, 100 insertions(+), 19 deletions(-)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-ensure-the-test-is-performed-at-the-right-page-boundary
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -39,6 +39,13 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 
+#define min(a, b) \
+	({ \
+		typeof(a) _a = (a); \
+		typeof(b) _b = (b); \
+		_a < _b ? _a : _b; \
+	})
+
 /* /proc/pid/maps parsing routines */
 struct page_content {
 	char *data;
@@ -77,6 +84,7 @@ FIXTURE(proc_maps_race)
 	struct line_content first_line;
 	unsigned long duration_sec;
 	int shared_mem_size;
+	int skip_pages;
 	int page_size;
 	int vma_count;
 	bool verbose;
@@ -105,38 +113,102 @@ struct vma_modifier_info {
 	void *child_mapped_addr[];
 };
 
-
-static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
+static bool read_page(FIXTURE_DATA(proc_maps_race) *self,
+		      struct page_content *page)
 {
 	ssize_t  bytes_read;
 
-	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
+	bytes_read = read(self->maps_fd, page->data, self->page_size);
+	if (bytes_read <= 0)
 		return false;
 
-	bytes_read = read(self->maps_fd, self->page1.data, self->page_size);
-	if (bytes_read <= 0)
+	/* Make sure data always ends with a newline character. */
+	if (page->data[bytes_read - 1] != '\n')
 		return false;
 
-	self->page1.size = bytes_read;
+	page->size = bytes_read;
 
-	bytes_read = read(self->maps_fd, self->page2.data, self->page_size);
-	if (bytes_read <= 0)
+	return true;
+}
+
+static bool parse_vma_line(char *line_start, char *line_end,
+			   unsigned long *start, unsigned long *end)
+{
+	bool found;
+
+	*line_end = '\0'; /* stop sscanf at the EOL */
+	found = (sscanf(line_start, "%lx-%lx", start, end) == 2);
+	*line_end = '\n';
+
+	return found;
+}
+
+static int locate_containing_page(FIXTURE_DATA(proc_maps_race) *self,
+				  unsigned long addr, unsigned long size)
+{
+	unsigned long start, end;
+	int page = 0;
+
+	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
+		return -1;
+
+	while (true) {
+		char *curr_pos;
+		char *end_pos;
+
+		if (!read_page(self, &self->page1))
+			return -1;
+
+		curr_pos = self->page1.data;
+		end_pos = self->page1.data + self->page1.size;
+		while (curr_pos < end_pos) {
+			char *line_end;
+
+			line_end = strchr(curr_pos, '\n');
+			if (!line_end)
+				break;
+
+			if (parse_vma_line(curr_pos, line_end, &start, &end) &&
+			    start == addr && end == addr + size)
+				return page;
+
+			curr_pos = line_end + 1;
+		}
+		page++;
+	}
+
+	return 0;
+}
+
+static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
+{
+	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
 		return false;
 
-	self->page2.size = bytes_read;
+	for (int i = 0; i < self->skip_pages; i++)
+		if (!read_page(self, &self->page1))
+			return false;
 
-	return true;
+	return read_page(self, &self->page1) && read_page(self, &self->page2);
 }
 
-static void copy_first_line(struct page_content *page, char *first_line)
+static void copy_line(const char *line_start, const char *line_end,
+		      char *buf, size_t buf_size)
 {
-	char *pos = strchr(page->data, '\n');
+	size_t len = min(line_end - line_start, buf_size - 1);
 
-	strncpy(first_line, page->data, pos - page->data);
-	first_line[pos - page->data] = '\0';
+	strncpy(buf, line_start, len);
+	buf[len] = '\0';
 }
 
-static void copy_last_line(struct page_content *page, char *last_line)
+static void copy_first_line(struct page_content *page, char *first_line,
+			    size_t line_size)
+{
+	copy_line(page->data, strchr(page->data, '\n'), first_line, line_size);
+}
+
+static void copy_last_line(struct page_content *page, char *last_line,
+			   size_t line_size)
 {
 	/* Get the last line in the first page */
 	const char *end = page->data + page->size - 1;
@@ -146,8 +218,8 @@ static void copy_last_line(struct page_c
 	/* search previous newline */
 	while (pos[-1] != '\n')
 		pos--;
-	strncpy(last_line, pos, end - pos);
-	last_line[end - pos] = '\0';
+
+	copy_line(pos, end, last_line, line_size);
 }
 
 /* Read the last line of the first page and the first line of the second page */
@@ -158,8 +230,8 @@ static bool read_boundary_lines(FIXTURE_
 	if (!read_two_pages(self))
 		return false;
 
-	copy_last_line(&self->page1, last_line->text);
-	copy_first_line(&self->page2, first_line->text);
+	copy_last_line(&self->page1, last_line->text, LINE_MAX_SIZE);
+	copy_first_line(&self->page2, first_line->text, LINE_MAX_SIZE);
 
 	return sscanf(last_line->text, "%lx-%lx", &last_line->start_addr,
 		      &last_line->end_addr) == 2 &&
@@ -418,6 +490,8 @@ FIXTURE_SETUP(proc_maps_race)
 	struct vma_modifier_info *mod_info;
 	pthread_mutexattr_t mutex_attr;
 	pthread_condattr_t cond_attr;
+	unsigned long first_map_addr;
+	unsigned long last_map_addr;
 	unsigned long duration_sec;
 	char fname[32];
 
@@ -502,6 +576,13 @@ FIXTURE_SETUP(proc_maps_race)
 	self->page2.data = malloc(self->page_size);
 	ASSERT_NE(self->page2.data, NULL);
 
+	first_map_addr = (unsigned long)mod_info->child_mapped_addr[0];
+	last_map_addr = (unsigned long)mod_info->child_mapped_addr[mod_info->vma_count - 1];
+
+	self->skip_pages = locate_containing_page(self,
+					min(first_map_addr, last_map_addr),
+					self->page_size * 3);
+	ASSERT_NE(self->skip_pages, -1);
 	ASSERT_TRUE(read_boundary_lines(self, &self->last_line, &self->first_line));
 
 	/*
_

Patches currently in -mm which might be from surenb@google.com are

fs-proc-task_mmu-read-proc-pid-smapsnuma_maps-under-per-vma-lock.patch
selftests-proc-ensure-the-test-is-performed-at-the-right-page-boundary.patch
selftests-proc-add-proc-pid-smaps-tearing-tests.patch

