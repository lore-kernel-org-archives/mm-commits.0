From: akpm@linux-foundation.org
Subject: + uml-code-tidying-under-arch-um-os-linux.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:25:35 -0700
Message-ID: <200710302225.l9UMPZxP031081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbXJ3W0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@linux.intel.com


The patch titled
     uml: code tidying under arch/um/os-Linux
has been added to the -mm tree.  Its filename is
     uml-code-tidying-under-arch-um-os-linux.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: code tidying under arch/um/os-Linux
From: WANG Cong <xiyou.wangcong@gmail.com>

This patch contains varied fixes and improvements for some files under
arch/um/os-Linux/, such as a typo fix in a perror message, a missing
argument fix for a printf, some constifying for pointers and so on.

[ jdike - made sigprocmask failure return -errno instead of -1 ]

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h        |   12 ++++++------
 arch/um/os-Linux/file.c     |   14 +++++++-------
 arch/um/os-Linux/main.c     |   12 ++++++++----
 arch/um/os-Linux/mem.c      |    5 ++++-
 arch/um/os-Linux/signal.c   |    3 ++-
 arch/um/os-Linux/start_up.c |    2 +-
 6 files changed, 28 insertions(+), 20 deletions(-)

diff -puN arch/um/include/os.h~uml-code-tidying-under-arch-um-os-linux arch/um/include/os.h
--- a/arch/um/include/os.h~uml-code-tidying-under-arch-um-os-linux
+++ a/arch/um/include/os.h
@@ -137,24 +137,24 @@ extern int os_set_owner(int fd, int pid)
 extern int os_mode_fd(int fd, int mode);
 
 extern int os_seek_file(int fd, unsigned long long offset);
-extern int os_open_file(char *file, struct openflags flags, int mode);
+extern int os_open_file(const char *file, struct openflags flags, int mode);
 extern int os_read_file(int fd, void *buf, int len);
 extern int os_write_file(int fd, const void *buf, int count);
-extern int os_file_size(char *file, unsigned long long *size_out);
-extern int os_file_modtime(char *file, unsigned long *modtime);
+extern int os_file_size(const char *file, unsigned long long *size_out);
+extern int os_file_modtime(const char *file, unsigned long *modtime);
 extern int os_pipe(int *fd, int stream, int close_on_exec);
 extern int os_set_fd_async(int fd, int owner);
 extern int os_clear_fd_async(int fd);
 extern int os_set_fd_block(int fd, int blocking);
 extern int os_accept_connection(int fd);
-extern int os_create_unix_socket(char *file, int len, int close_on_exec);
+extern int os_create_unix_socket(const char *file, int len, int close_on_exec);
 extern int os_shutdown_socket(int fd, int r, int w);
 extern void os_close_file(int fd);
 extern int os_rcv_fd(int fd, int *helper_pid_out);
 extern int create_unix_socket(char *file, int len, int close_on_exec);
-extern int os_connect_socket(char *name);
+extern int os_connect_socket(const char *name);
 extern int os_file_type(char *file);
-extern int os_file_mode(char *file, struct openflags *mode_out);
+extern int os_file_mode(const char *file, struct openflags *mode_out);
 extern int os_lock_file(int fd, int excl);
 extern void os_flush_stdout(void);
 extern int os_stat_filesystem(char *path, long *bsize_out,
diff -puN arch/um/os-Linux/file.c~uml-code-tidying-under-arch-um-os-linux arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-code-tidying-under-arch-um-os-linux
+++ a/arch/um/os-Linux/file.c
@@ -19,7 +19,7 @@
 #include "user.h"
 #include "kern_util.h"
 
-static void copy_stat(struct uml_stat *dst, struct stat64 *src)
+static void copy_stat(struct uml_stat *dst, const struct stat64 *src)
 {
 	*dst = ((struct uml_stat) {
 		.ust_dev     = src->st_dev,     /* device */
@@ -168,7 +168,7 @@ int os_file_type(char *file)
 	else return OS_TYPE_FILE;
 }
 
-int os_file_mode(char *file, struct openflags *mode_out)
+int os_file_mode(const char *file, struct openflags *mode_out)
 {
 	int err;
 
@@ -189,7 +189,7 @@ int os_file_mode(char *file, struct open
 	return err;
 }
 
-int os_open_file(char *file, struct openflags flags, int mode)
+int os_open_file(const char *file, struct openflags flags, int mode)
 {
 	int fd, err, f = 0;
 
@@ -216,7 +216,7 @@ int os_open_file(char *file, struct open
 	return fd;
 }
 
-int os_connect_socket(char *name)
+int os_connect_socket(const char *name)
 {
 	struct sockaddr_un sock;
 	int fd, err;
@@ -277,7 +277,7 @@ int os_write_file(int fd, const void *bu
 	return n;
 }
 
-int os_file_size(char *file, unsigned long long *size_out)
+int os_file_size(const char *file, unsigned long long *size_out)
 {
 	struct uml_stat buf;
 	int err;
@@ -314,7 +314,7 @@ int os_file_size(char *file, unsigned lo
 	return 0;
 }
 
-int os_file_modtime(char *file, unsigned long *modtime)
+int os_file_modtime(const char *file, unsigned long *modtime)
 {
 	struct uml_stat buf;
 	int err;
@@ -515,7 +515,7 @@ int os_rcv_fd(int fd, int *helper_pid_ou
 	return new;
 }
 
-int os_create_unix_socket(char *file, int len, int close_on_exec)
+int os_create_unix_socket(const char *file, int len, int close_on_exec)
 {
 	struct sockaddr_un addr;
 	int sock, err;
diff -puN arch/um/os-Linux/main.c~uml-code-tidying-under-arch-um-os-linux arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-code-tidying-under-arch-um-os-linux
+++ a/arch/um/os-Linux/main.c
@@ -73,7 +73,7 @@ static void install_fatal_handler(int si
 	action.sa_handler = last_ditch_exit;
 	if (sigaction(sig, &action, NULL) < 0) {
 		printf("failed to install handler for signal %d - errno = %d\n",
-		       errno);
+		       sig, errno);
 		exit(1);
 	}
 }
@@ -92,7 +92,8 @@ static void setup_env_path(void)
 	 * just use the default + /usr/lib/uml
 	 */
 	if (!old_path || (path_len = strlen(old_path)) == 0) {
-		putenv("PATH=:/bin:/usr/bin/" UML_LIB_PATH);
+		if (putenv("PATH=:/bin:/usr/bin/" UML_LIB_PATH))
+			perror("couldn't putenv");
 		return;
 	}
 
@@ -100,11 +101,14 @@ static void setup_env_path(void)
 	path_len += strlen("PATH=" UML_LIB_PATH) + 1;
 	new_path = malloc(path_len);
 	if (!new_path) {
-		perror("coudn't malloc to set a new PATH");
+		perror("couldn't malloc to set a new PATH");
 		return;
 	}
 	snprintf(new_path, path_len, "PATH=%s" UML_LIB_PATH, old_path);
-	putenv(new_path);
+	if (putenv(new_path)) {
+		perror("couldn't putenv to set a new PATH");
+		free(new_path);
+	}
 }
 
 extern int uml_exitcode;
diff -puN arch/um/os-Linux/mem.c~uml-code-tidying-under-arch-um-os-linux arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-code-tidying-under-arch-um-os-linux
+++ a/arch/um/os-Linux/mem.c
@@ -172,13 +172,15 @@ int __init make_tempfile(const char *tem
 
 	which_tmpdir();
 	tempname = malloc(MAXPATHLEN);
+	if (!tempname)
+		goto out;
 
 	find_tempdir();
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
 	else
 		tempname[0] = '\0';
-	strcat(tempname, template);
+	strncat(tempname, template, MAXPATHLEN-1-strlen(tempname));
 	fd = mkstemp(tempname);
 	if(fd < 0){
 		fprintf(stderr, "open - cannot create %s: %s\n", tempname,
@@ -268,6 +270,7 @@ void __init check_tmpexec(void)
 	if(addr == MAP_FAILED){
 		err = errno;
 		perror("failed");
+		close(fd);
 		if(err == EPERM)
 			printf("%s must be not mounted noexec\n",tempdir);
 		exit(1);
diff -puN arch/um/os-Linux/signal.c~uml-code-tidying-under-arch-um-os-linux arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-code-tidying-under-arch-um-os-linux
+++ a/arch/um/os-Linux/signal.c
@@ -183,7 +183,8 @@ int change_sig(int signal, int on)
 
 	sigemptyset(&sigset);
 	sigaddset(&sigset, signal);
-	sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old);
+	if (sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old) < 0)
+		return -errno;
 	return !sigismember(&old, signal);
 }
 
diff -puN arch/um/os-Linux/start_up.c~uml-code-tidying-under-arch-um-os-linux arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-code-tidying-under-arch-um-os-linux
+++ a/arch/um/os-Linux/start_up.c
@@ -63,7 +63,7 @@ static int ptrace_child(void)
 	_exit(ret);
 }
 
-static void fatal_perror(char *str)
+static void fatal_perror(const char *str)
 {
 	perror(str);
 	exit(1);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
git-watchdog.patch
arch-um-drivers-ubd_kernc-a-warning-fix.patch
uml-code-tidying-under-arch-um-os-linux.patch
