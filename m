Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C036156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810166; cv=none; b=XWk1x2wKnMgpMZAa/9a3qCuqSfpXVTjOhg3K+LTJ04SamoPolxWpFL8R2HlKEyQAkvcezwT1MrqSOhjxiPxG8bOygZRc+09IofIlJgDHMhTMS3wcMy0Jpok3S1atgkXDIYsuicsfdQWnnVP3HTyhxvl0+UvlVsw7eqIsaCBFnsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810166; c=relaxed/simple;
	bh=xKuMAd0kzgJZBghc32nQxzVfo/Z/JePulYD6Z8fuSaU=;
	h=Date:To:From:Subject:Message-Id; b=c3t6S+PIOdx1BTa/IRQ9UHxExANld3K5lxW/7csKmayJe+/Xxht/mfOjS27gU/yvNdlfhfGg573spcck9fIHQrgMVBFbVg8cd1RIs9NewVsFOm7wxvYiIZMgn2hOuOX5argctBRlpdG4b4/xUOyCeZItxw44/x9t5RBSDHoQ1aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nk0o4Ske; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nk0o4Ske"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0319BC4CEEB;
	Sun, 14 Sep 2025 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810166;
	bh=xKuMAd0kzgJZBghc32nQxzVfo/Z/JePulYD6Z8fuSaU=;
	h=Date:To:From:Subject:From;
	b=Nk0o4SkeRdxQPFGw3yXMfr5q50DYS2ehDhHzcQzmyMs1S021Cb/+EHVTzD+0dRr27
	 EUYmfa11japfO7clNGiXqf7BlBLaWT8NT0XgEdaRWoV28JHt6xFc/Ct+3fkBAp7R5D
	 CicdcX219sVVMNBIUh16sI1vgNqheP80VUDfyhBA=
Date: Sat, 13 Sep 2025 17:36:05 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-delaytop-add-interactive-mode-with-keyboard-controls.patch removed from -mm tree
Message-Id: <20250914003606.0319BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/delaytop: add interactive mode with keyboard controls
has been removed from the -mm tree.  Its filename was
     tools-delaytop-add-interactive-mode-with-keyboard-controls.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fan Yu <fan.yu9@zte.com.cn>
Subject: tools/delaytop: add interactive mode with keyboard controls
Date: Sun, 7 Sep 2025 00:13:38 +0800 (CST)

The original delaytop only supported static output with limited
interaction.  Users had to restart the tool with different command-line
options to change sorting or display modes, which disrupted continuous
monitoring and reduced productivity during performance investigations.

Adds real-time interactive controls through keyboard input:
1) Add interactive menu system with visual prompts
2) Support dynamic sorting changes without restarting
3) Enable toggle of memory verbose mode with 'M' key

The interactive mode transforms delaytop from a static monitoring tool
into a dynamic investigation platform, allowing users to adapt the view in
real-time based on observed performance patterns.

Link: https://lkml.kernel.org/r/20250907001338580EURha20BxWFmBSrUpS8D1@zte.com.cn
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/delaytop.c |  166 ++++++++++++++++++++++++----------
 1 file changed, 121 insertions(+), 45 deletions(-)

--- a/tools/accounting/delaytop.c~tools-delaytop-add-interactive-mode-with-keyboard-controls
+++ a/tools/accounting/delaytop.c
@@ -73,8 +73,8 @@
 #define PSI_LINE_FORMAT "%-12s %6.1f%%/%6.1f%%/%6.1f%%/%8llu(ms)\n"
 #define DELAY_FMT_DEFAULT "%8.2f %8.2f %8.2f %8.2f\n"
 #define DELAY_FMT_MEMVERBOSE "%8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n"
-#define SORT_FIELD(name, modes) \
-	{#name, \
+#define SORT_FIELD(name, cmd, modes) \
+	{#name, #cmd, \
 	offsetof(struct task_info, name##_delay_total), \
 	offsetof(struct task_info, name##_count), \
 	modes}
@@ -140,6 +140,7 @@ struct container_stats {
 /* Delay field structure */
 struct field_desc {
 	const char *name;	/* Field name for cmdline argument */
+	const char *cmd_char;	/* Interactive command */
 	unsigned long total_offset; /* Offset of total delay in task_info */
 	unsigned long count_offset; /* Offset of count in task_info */
 	size_t supported_modes; /* Supported display modes */
@@ -165,17 +166,18 @@ static int task_count;
 static int running = 1;
 static struct container_stats container_stats;
 static const struct field_desc sort_fields[] = {
-	SORT_FIELD(cpu,		MODE_DEFAULT),
-	SORT_FIELD(blkio,	MODE_DEFAULT),
-	SORT_FIELD(irq,		MODE_DEFAULT),
-	SORT_FIELD(mem,		MODE_DEFAULT | MODE_MEMVERBOSE),
-	SORT_FIELD(swapin,	MODE_MEMVERBOSE),
-	SORT_FIELD(freepages,	MODE_MEMVERBOSE),
-	SORT_FIELD(thrashing,	MODE_MEMVERBOSE),
-	SORT_FIELD(compact,	MODE_MEMVERBOSE),
-	SORT_FIELD(wpcopy,	MODE_MEMVERBOSE),
+	SORT_FIELD(cpu,		c,	MODE_DEFAULT),
+	SORT_FIELD(blkio,	i,	MODE_DEFAULT),
+	SORT_FIELD(irq,		q,	MODE_DEFAULT),
+	SORT_FIELD(mem,		m,	MODE_DEFAULT | MODE_MEMVERBOSE),
+	SORT_FIELD(swapin,	s,	MODE_MEMVERBOSE),
+	SORT_FIELD(freepages,	r,	MODE_MEMVERBOSE),
+	SORT_FIELD(thrashing,	t,	MODE_MEMVERBOSE),
+	SORT_FIELD(compact,	p,	MODE_MEMVERBOSE),
+	SORT_FIELD(wpcopy,	w,	MODE_MEMVERBOSE),
 	END_FIELD
 };
+static int sort_selected;
 
 /* Netlink socket variables */
 static int nl_sd = -1;
@@ -197,6 +199,19 @@ static void disable_raw_mode(void)
 	tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
 }
 
+/* Find field descriptor by command line */
+static const struct field_desc *get_field_by_cmd_char(char ch)
+{
+	const struct field_desc *field;
+
+	for (field = sort_fields; field->name != NULL; field++) {
+		if (field->cmd_char[0] == ch)
+			return field;
+	}
+
+	return NULL;
+}
+
 /* Find field descriptor by name with string comparison */
 static const struct field_desc *get_field_by_name(const char *name)
 {
@@ -870,6 +885,18 @@ static void display_results(void)
 			container_stats.nr_stopped, container_stats.nr_uninterruptible,
 			container_stats.nr_io_wait);
 	}
+
+	/* Interacive command */
+	suc &= BOOL_FPRINT(out, "[o]sort [M]memverbose [q]quit\n");
+	if (sort_selected) {
+		if (cfg.display_mode == MODE_MEMVERBOSE)
+			suc &= BOOL_FPRINT(out,
+				"sort selection: [m]MEM [r]RCL [t]THR [p]CMP [w]WP\n");
+		else
+			suc &= BOOL_FPRINT(out,
+				"sort selection: [c]CPU [i]IO [m]MEM [q]IRQ\n");
+	}
+
 	/* Task delay output */
 	suc &= BOOL_FPRINT(out, "Top %d processes (sorted by %s delay):\n",
 			cfg.max_processes, get_name_by_field(cfg.sort_field));
@@ -919,11 +946,78 @@ static void display_results(void)
 		perror("Error writing to output");
 }
 
+/* Check for keyboard input with timeout based on cfg.delay */
+static char check_for_keypress(void)
+{
+	struct timeval tv = {cfg.delay, 0};
+	fd_set readfds;
+	char ch = 0;
+
+	FD_ZERO(&readfds);
+	FD_SET(STDIN_FILENO, &readfds);
+	int r = select(STDIN_FILENO + 1, &readfds, NULL, NULL, &tv);
+
+	if (r > 0 && FD_ISSET(STDIN_FILENO, &readfds)) {
+		read(STDIN_FILENO, &ch, 1);
+		return ch;
+	}
+
+	return 0;
+}
+
+#define MAX_MODE_SIZE 2
+static void toggle_display_mode(void)
+{
+	static const size_t modes[MAX_MODE_SIZE] = {MODE_DEFAULT, MODE_MEMVERBOSE};
+	static size_t cur_index;
+
+	cur_index = (cur_index + 1) % MAX_MODE_SIZE;
+	cfg.display_mode = modes[cur_index];
+}
+
+/* Handle keyboard input: sorting selection, mode toggle, or quit */
+static void handle_keypress(char ch, int *running)
+{
+	const struct field_desc *field;
+
+	/* Change sort field */
+	if (sort_selected) {
+		field = get_field_by_cmd_char(ch);
+		if (field && (field->supported_modes & cfg.display_mode))
+			cfg.sort_field = field;
+
+		sort_selected = 0;
+	/* Handle mode changes or quit */
+	} else {
+		switch (ch) {
+		case 'o':
+			sort_selected = 1;
+			break;
+		case 'M':
+			toggle_display_mode();
+			for (field = sort_fields; field->name != NULL; field++) {
+				if (field->supported_modes & cfg.display_mode) {
+					cfg.sort_field = field;
+					break;
+				}
+			}
+			break;
+		case 'q':
+		case 'Q':
+			*running = 0;
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 /* Main function */
 int main(int argc, char **argv)
 {
+	const struct field_desc *field;
 	int iterations = 0;
-	int use_q_quit = 0;
+	char keypress;
 
 	/* Parse command line arguments */
 	parse_args(argc, argv);
@@ -943,20 +1037,20 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	if (!cfg.output_one_time) {
-		use_q_quit = 1;
-		enable_raw_mode();
-		printf("Press 'q' to quit.\n");
-		fflush(stdout);
-	}
+	/* Set terminal to non-canonical mode for interaction */
+	enable_raw_mode();
 
 	/* Main loop */
 	while (running) {
-		/* Exit when sort field do not match display mode */
+		/* Auto-switch sort field when not matching display mode */
 		if (!(cfg.sort_field->supported_modes & cfg.display_mode)) {
-			fprintf(stderr, "Sort field not supported in this mode\n");
-			display_available_fields(cfg.display_mode);
-			break;
+			for (field = sort_fields; field->name != NULL; field++) {
+				if (field->supported_modes & cfg.display_mode) {
+					cfg.sort_field = field;
+					printf("Auto-switched sort field to: %s\n", field->name);
+					break;
+				}
+			}
 		}
 
 		/* Read PSI statistics */
@@ -983,32 +1077,14 @@ int main(int argc, char **argv)
 		if (cfg.output_one_time)
 			break;
 
-		/* Check for 'q' key to quit */
-		if (use_q_quit) {
-			struct timeval tv = {cfg.delay, 0};
-			fd_set readfds;
-
-			FD_ZERO(&readfds);
-			FD_SET(STDIN_FILENO, &readfds);
-			int r = select(STDIN_FILENO+1, &readfds, NULL, NULL, &tv);
-
-			if (r > 0 && FD_ISSET(STDIN_FILENO, &readfds)) {
-				char ch = 0;
-
-				read(STDIN_FILENO, &ch, 1);
-				if (ch == 'q' || ch == 'Q') {
-					running = 0;
-					break;
-				}
-			}
-		} else {
-			sleep(cfg.delay);
-		}
+		/* Keypress for interactive usage */
+		keypress = check_for_keypress();
+		if (keypress)
+			handle_keypress(keypress, &running);
 	}
 
 	/* Restore terminal mode */
-	if (use_q_quit)
-		disable_raw_mode();
+	disable_raw_mode();
 
 	/* Cleanup */
 	close(nl_sd);
_

Patches currently in -mm which might be from fan.yu9@zte.com.cn are


